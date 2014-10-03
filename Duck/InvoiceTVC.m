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
@synthesize numberFormatter = _numberFormatter;
@synthesize datePicker = _datePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    _datePicker = [[UIDatePicker alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"Invoice";
    [[self tableView] reloadData];
}

-(NSArray *)sortedInvoicePhotos {
    NSSet * invoicePhotos = _invoice.photos;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"documentName" ascending:NO];
    NSArray * sortDescriptors = @[sortDescriptor];
    return [invoicePhotos sortedArrayUsingDescriptors:sortDescriptors];
}

-(NSArray *)sortedBottlesInInvoice {
    NSSet * bottlesInInvoice = _invoice.invoicesByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    return [bottlesInInvoice sortedArrayUsingDescriptors:sortDescriptors];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { // the photos
        return [[self sortedInvoicePhotos] count];
    } else if (section == 1) { // bottles
        return 1;
    } else  if (section == 2){ // vendor
        return 1;
    } else if (section == 3){ // order
        return 1;
    } else if (section == 4){ // date
        return 1;
    } else { // shouldnt happen
        abort();
    }
}


// NOTE: A lot of this code is repeated in OrderTableViewController and should be abstracted
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice Photo CellReuse ID" forIndexPath:indexPath];
    if (indexPath.section == 0) { // invoice photos
        InvoicePhoto * invoicePhoto = [[self sortedInvoicePhotos] objectAtIndex:indexPath.row];
        NSString * documentName = invoicePhoto.documentName;
        UIImage * image = [self loadImage:documentName];
        cell.imageView.image = image;
        cell.textLabel.text = [NSString stringWithFormat:@""];
    } else if (indexPath.section == 1) { // bottles
        cell.textLabel.text = [NSString stringWithFormat:@"%d skus entered for invoice", _invoice.invoicesByBottle.count];
    } else if (indexPath.section == 2){ // vendor
        Vendor * vendor = _invoice.vendor;
        NSString * vendorName = [Vendor fullNameOfVendor:vendor];
        cell.textLabel.text = vendorName ? vendorName : @"No name";
        cell.detailTextLabel.text = vendor.email ? vendor.email : @"No Email";
    } else if (indexPath.section == 3){ // order
        Order * order = _invoice.order;
        cell.textLabel.text = order ? [Order description:order withNumForatter:_numberFormatter] : @"Linked Order";
    } else if (indexPath.section == 4){ // date
        _datePicker.date = _invoice.dateReceived ? _invoice.dateReceived : [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_datePicker];
        cell.textLabel.text = @"";
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"photos of invoice";
    } else if (section == 1) {
        return @"skus in invoice";
    } else if (section == 2) {
        return @"vendor";
    } else if (section == 3){ // order
        return @"order for invoice";
    } else if (section == 4) {
        return @"date received";
    } else {
        return @"";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Click Add Photo above to take pictures of your invoice";
            break;
        case 1:
            return @"Enter the skus as seen on your invoice";
            break;
        default:
            return @"";
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) { // its the date picker section (only one row)
        return _datePicker.bounds.size.height;
    }
    return 44; // defaultl cell height
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"Show Invoice Photo Segue ID" sender:cell];
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"Show Bottles In Invoice" sender:nil];
    } else if (indexPath.section == 2) {
        [self alertForPickingManualOrFromAddressBook:@"Pick vendor from address book, or enter manually?"];
    } else if (indexPath.section == 3) {
        [self performSegueWithIdentifier:@"Show Order Picker" sender:nil];
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
        // NOTE: This should be abstracted in an InvoicePhoto category
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

-(void)dateChanged {
    _invoice.dateReceived = _datePicker.date;
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
    } else if ([segue.identifier isEqualToString:@"Show Bottles In Invoice"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setInvoice:_invoice];
    } else if ([segue.identifier isEqualToString:@"Show Vendor Contact Info Segue ID"]) {
        [segue.destinationViewController setVendor:_invoice.vendor];
    } else if ([segue.identifier isEqualToString:@"Show Order Picker"]) {
        PickOrderTVC * tvc = segue.destinationViewController;
        tvc.delegate = self;
        [tvc setManagedObjectContext:_managedObjectContext];
        [tvc setNumberFormatter:_numberFormatter];
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

    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];

    
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
    

    
    [self dismissViewControllerAnimated:YES completion:^{[self.tableView reloadData];}];

}

//
// NOTE most of the below is repeated in OrderTVC
//


-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    Vendor * vendor = [Vendor newVendorForRef:person inContext:_managedObjectContext];
    _invoice.vendor = vendor;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Address picker
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma Alert View Delegate methods
// Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) { // asking user to select how to pick their vendor
        if (buttonIndex == 0) { // "Address Book"
            [self showPeoplePicker];
        } else if (buttonIndex == 1) { // "Manually Enter"
            [self performSegueWithIdentifier:@"Show Vendor Contact Info Segue ID" sender:nil];
        }
    }
}

#pragma utils

-(void)alertForPickingManualOrFromAddressBook:(NSString *)message {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Address Book", @"Manually", nil];
    alert.tag = 1;
    [alert show];
}

-(void)showPeoplePicker {
    ABPeoplePickerNavigationController * peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}

#pragma Pick Order delegate methods

-(void)didSelectOrder:(Order *)order {
    if ([_invoice.order isEqual:order]) {
        _invoice.order = nil;
    } else {
        _invoice.order = order;
    }

    [self.tableView reloadData];
    [[self navigationController] popViewControllerAnimated:YES];
    
}
-(BOOL)orderIsSelected:(Order *)order {
    return [_invoice.order isEqual:order];
}

@end
