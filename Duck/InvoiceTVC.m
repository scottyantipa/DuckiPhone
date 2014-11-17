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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_skusToolTip != nil) {
        [_skusToolTip dismissAnimated:YES];
        _skusToolTip = nil;
    }
    self.title = @"Invoice";
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([NSUserDefaultsManager isFirstTimeShowingClass:NSStringFromClass([self class])]) {
        [self showHint];
    }
}


-(void)showHint {
    _skusToolTip = [[CMPopTipViewStyleOverride alloc] initWithMessage:@"Enter the bottles in this invoice"];
    _skusToolTip.delegate = self;
    [CMPopTipViewStyleOverride setStylesForPopup:_skusToolTip];
    NSIndexPath * skusPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell * skusCell = [self.tableView cellForRowAtIndexPath:skusPath];
    [_skusToolTip presentPointingAtView:skusCell inView:self.view animated:YES];
}

#pragma Delegate methods for tool tip
-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self performSegueWithIdentifier:@"Show Bottles In Invoice" sender:nil];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_skusToolTip != nil) {
        [_skusToolTip dismissAnimated:YES];
    }
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


// NOTE: A lot of this code is repeated in OrderTableViewController and should be abstracted
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice Photo CellReuse ID" forIndexPath:indexPath];
    if (indexPath.section == 0) { // bottles
        cell.textLabel.text = [Invoice contentsDescriptionForInvoice:_invoice];
    } else if (indexPath.section == 1){ // vendor
        Vendor * vendor = _invoice.vendor;
        NSString * vendorName = [Vendor fullNameOfVendor:vendor];
        cell.textLabel.text = vendorName ? vendorName : @"No name";
        cell.detailTextLabel.text = vendor.email ? vendor.email : @"No Email";
    } else if (indexPath.section == 2){ // order
        Order * order = _invoice.order;
        cell.textLabel.text = order ? [Order description:order withNumForatter:_numberFormatter] : @"Linked Order";
    } else if (indexPath.section == 3){ // date
        _datePicker.date = _invoice.dateReceived ? _invoice.dateReceived : [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_datePicker];
        cell.textLabel.text = @"";
    }
    if (indexPath.section != 3) { // all but the date picker
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"skus in invoice";
    } else if (section == 1) {
        return @"vendor";
    } else if (section == 2){ // order
        return @"order for invoice";
    } else if (section == 3) {
        return @"date received";
    } else {
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) { // its the date picker section (only one row)
        return _datePicker.bounds.size.height;
    }
    return 44; // defaultl cell height
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"Show Bottles In Invoice" sender:nil];
    } else if (indexPath.section == 1) {
        [self alertForPickingManualOrFromAddressBook:@"Pick vendor from address book, or enter manually?"];
    } else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"Show Order Picker" sender:nil];
    }
}


-(void)dateChanged {
    _invoice.dateReceived = _datePicker.date;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Bottles In Invoice"]) {
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




// delete the invoice and all of its InvoiceForBottle
- (IBAction)didDelete:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    for (InvoiceForBottle * invoiceForBottle in _invoice.invoicesByBottle) {
        [_managedObjectContext deleteObject:invoiceForBottle];
    }
    [_managedObjectContext deleteObject:_invoice];
    NSError *err;
    [_managedObjectContext save:&err];
    
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
