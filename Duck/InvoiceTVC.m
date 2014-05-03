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
@synthesize sortedInvoicePhotos = _sortedInvoicePhotos;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Invoice";
}

-(void)viewWillAppear:(BOOL)animated {
    NSSet * invoicePhotos = _invoice.photos;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"documentName" ascending:NO];
    NSArray * sortDescriptors = @[sortDescriptor];
    _sortedInvoicePhotos = [invoicePhotos sortedArrayUsingDescriptors:sortDescriptors];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _invoice.photos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice TVC CellReuse ID" forIndexPath:indexPath];
    InvoicePhoto * invoicePhoto = [_sortedInvoicePhotos objectAtIndex:indexPath.row];
    NSString * documentName = invoicePhoto.documentName;
    UIImage * image = [self loadImage:documentName];
    cell.imageView.image = image;
                                   
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    }
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];

    
    // NOTE: this logic for creating InvoicePhoto should be extracted into a InvoicePhoto+Create category
    
    // create the photo name to be stored in core data
    NSDate * now = [NSDate date];
    double interval = [now timeIntervalSince1970];
    NSString * documentName = [[NSNumber numberWithDouble:interval] stringValue];
    
    // store the photo in app /Documents folder
    //(from this example: http://beageek.biz/save-and-load-uiimage-in-documents-directory-on-iphone-xcode-ios/)
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", documentName]];
    NSData * data = UIImagePNGRepresentation(chosenImage);
    [data writeToFile:path atomically:YES];

    // create the invoicePhoto
    InvoicePhoto * invoicePhoto = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicePhoto" inManagedObjectContext:_managedObjectContext];
    invoicePhoto.invoice = _invoice;
    invoicePhoto.documentName = documentName;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Image Picker Delegate

@end
