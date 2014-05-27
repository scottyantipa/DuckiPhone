//
//  InvoiceTVC.m
//  Duck
//
//  Created by Scott Antipa on 5/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "InvoiceTVC.h"

@interface InvoiceTVC ()

@end

@implementation InvoiceTVC
@synthesize invoice = _invoice;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"Invoice";
    // NOTE: Should I call this here? Or should this be done immediately when a new bottle is added to an order
    [self recognizeAllBottlesFromAllPhotos];
}

-(NSArray *)sortedInvoicePhotos {
    NSSet * invoicePhotos = _invoice.photos;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"documentName" ascending:NO];
    NSArray * sortDescriptors = @[sortDescriptor];
    return [invoicePhotos sortedArrayUsingDescriptors:sortDescriptors];
}

-(NSArray *)sortedBottlesInOrder {
    return [Order getSortedBottlesInOrder:_invoice.order];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { // the photos
        return [[self sortedInvoicePhotos] count];
    } else if (section == 1) {
        return [[ self sortedBottlesInOrder] count];
    } else {
        return 0;
    }
}

// NOTE: This should be a method within InvoicePhoto+Create
-(void)recognizeAllBottlesFromAllPhotos {
    for (InvoicePhoto * invoicePhoto in _invoice.photos) {
        [self recognizeBottlesForInvoicePhoto:invoicePhoto];
    }
}

-(void)recognizeBottlesForInvoicePhoto:(InvoicePhoto *)invoicePhoto {
    if (invoicePhoto.text != nil) {
        NSSet * recognizedBottles = [Bottle bottlesFromSearchText:invoicePhoto.text withOrder:_invoice.order];
        if (recognizedBottles.count != 0) {
            [invoicePhoto addBottles:recognizedBottles];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.section == 0) { // invoice photos
        cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice Photo CellReuse ID" forIndexPath:indexPath];
        InvoicePhoto * invoicePhoto = [[self sortedInvoicePhotos] objectAtIndex:indexPath.row];
        NSString * documentName = invoicePhoto.documentName;
        UIImage * image = [self loadImage:documentName];
        cell.imageView.image = image;
        cell.textLabel.text = [NSString stringWithFormat:@"photo %d", indexPath.row + 1];
    } else if (indexPath.section == 1) { // bottles
        cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice Bottle CellReuse ID" forIndexPath:indexPath];
        OrderForBottle * orderForBottle = [[self sortedBottlesInOrder] objectAtIndex:indexPath.row];
        Bottle * thisBottle = orderForBottle.whichBottle;
        cell.textLabel.text = thisBottle.name;

        // loop through the photos and see if this bottle has already been recognized
        // and put a checkmark next to it if so
        BOOL wasRecognized = false;
        for (InvoicePhoto * photo in [self sortedInvoicePhotos]) {
            if (wasRecognized) {
                break;
            }
            NSSet * bottles = photo.bottles;
            for (Bottle * recognizedBottle in bottles) {
                if ([thisBottle.barcode isEqualToString:recognizedBottle.barcode]) { // verify same bottle using barcode
                    wasRecognized = YES;
                    break;
                }
            }
        }
        if (wasRecognized) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString * footer;
    if (section == 0) { // photos
        footer = @"We use text recognition to recognize bottles from your invoice.  Add as many as you'd like to increase accuracy (we won't add duplicate bottles).";
    } else if (section == 1) { // bottles
        footer = @"These are the bottles you listed in your order.  Bottles with a checkmark have been recognized through text recognition in an invoice photo.";
    }
    return footer;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * header;
    if (section == 0) {
        header = @"invoice photos";
    } else if (section == 1) {
        header = @"bottles from your order";
    }
    return header;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"Show Invoice Photo Segue ID" sender:cell];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // the photos can be deleted
        return YES;
    } else {
        return NO; // not the bottles in order
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // delete the invoice photo
        InvoicePhoto * invoicePhoto = [[self sortedInvoicePhotos] objectAtIndex:indexPath.row];
        [self deleteImageForName:invoicePhoto.documentName];    
        // NOTE: This should be abstracted in an InvoicePhoto cateogry or something
        [_managedObjectContext deleteObject:invoicePhoto];

        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[self tableView] reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([[segue destinationViewController] respondsToSelector:@selector(setInvoiceImage:)]) {
        InvoicePhoto * invoicePhoto = [[self sortedInvoicePhotos] objectAtIndex:indexPath.row];
        UIImage * invoiceImage = [self loadImage:invoicePhoto.documentName];
        [[segue destinationViewController] setInvoiceImage:invoiceImage];
    }
}


#pragma utils

-(UIImage *)loadImage:(NSString *)documentName {
    //NOTE: this code is repeated in save and load image
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", documentName]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}

#pragma Button Delegate

- (IBAction)didSelectAddPhoto:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0) { // take photo
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) { // choose existing photo
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

// store the image in app /Documents folder
//(from this example: http://beageek.biz/save-and-load-uiimage-in-documents-directory-on-iphone-xcode-ios/)
-(void)storeImage:(UIImage *)image forName:(NSString *)name {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    NSData * data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];

}

-(void)deleteImageForName:(NSString *)name {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    // NOTE: this logic for creating InvoicePhoto should be extracted into a InvoicePhoto+Create category

    UIImage * original = info[UIImagePickerControllerEditedImage];
    UIImage * chosenImage = [self convertImage:original];
    
    // create the photo name to be stored in core data
    NSDate * now = [NSDate date];
    double interval = [now timeIntervalSince1970];
    NSString * documentName = [[NSNumber numberWithDouble:interval] stringValue];
    
    // store the photo in app /Documents folder
    //(from this example: http://beageek.biz/save-and-load-uiimage-in-documents-directory-on-iphone-xcode-ios/)
    [self storeImage:chosenImage forName:documentName];
    
    // create the invoicePhoto class instance
    InvoicePhoto * invoicePhoto = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicePhoto" inManagedObjectContext:_managedObjectContext];
    invoicePhoto.invoice = _invoice;
    invoicePhoto.documentName = documentName;
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // close camera and show spinner while tesseract does its job
    [self dismissViewControllerAnimated:YES completion:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.color = [UIColor blueColor];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    // run tesseract in background while displaying a spinner
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Tesseract * tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        [tesseract setImage:chosenImage];
        [tesseract recognize];
        NSString * recognizedText = [tesseract recognizedText];
        invoicePhoto.text = recognizedText;
        [self recognizeBottlesForInvoicePhoto:invoicePhoto];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
            [spinner removeFromSuperview];
        });
    });
}

-(UIImage *)convertImage:(UIImage *)src {
    return [self toGrayscale:src];
}

-(CGFloat)radians:(CGFloat)degrees {
    return degrees * M_PI / 180.0;
}

// got this from here: http://stackoverflow.com/questions/13511102/ios-tesseract-ocr-image-preperation
- (UIImage *) toGrayscale:(UIImage*)img
{
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, img.size.width * img.scale, img.size.height * img.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [img CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method:     http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:img.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

#pragma Image Picker Delegate

@end
