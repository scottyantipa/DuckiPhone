//
//  NewOrderTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "OrderTableViewController.h"

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;
@synthesize datePicker = _datePicker;
@synthesize numberFormatter = _numberFormatter;
@synthesize addressBook = _addressBook;


// Lazy instantiate an order if there isn't one.  If there is an order, add affordance
// to Re-order from the vendor.  Also intialize class vars -- order, datePicker
- (void)viewDidLoad
{
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    _datePicker = [[UIDatePicker alloc] init];
    
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (!_order) { // this is a new order to display
        _order = [Order newOrderForDate:[NSDate date] inManagedObjectContext:_managedObjectContext];
    }
    
    // create button to order from vendor
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int reOrderButtonHeight = 35;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, reOrderButtonHeight)];
    UIButton * orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [orderButton addTarget:self action:@selector(didSelectSendOrder) forControlEvents:UIControlEventTouchUpInside];
    [orderButton setTitle:@"Send Order to Vendor" forState:UIControlStateNormal];
    orderButton.frame = CGRectMake(0, 0, screenWidth, reOrderButtonHeight);
    [headerView addSubview:orderButton];
    self.tableView.tableHeaderView = headerView;
    self.title = @"Order";
    [super viewDidLoad];
}

// We do this because the _order can be edited by
// a view before/after it
-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Bottles in Order Segue ID"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setOrder:_order];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { // vendor
        return 1; // name
    } else if (section == 1) { // contents
        return 2; // number of bottles, dollar amount
    } else { // date picker
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // There will need to be 3 rows:  Bottles in Order, Date, Total Amount
    NSString * cellID = [NSString stringWithFormat:@"New Order CellID"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSString * labelText;
    NSString * detailText;
    NSString * noNameText = @"No name for vendor";
    if (indexPath.section == 0) { // vendor information
        Vendor * vendor = _order.whichVendor;
        NSString * vendorName = [Vendor fullNameOfVendor:vendor];
        NSString * vendorEmail = vendor.email;
        labelText = vendorName ? vendorName : noNameText;
        detailText = vendorEmail ? vendorEmail : @"No Email For Vendor";
    }
    else if (indexPath.section == 1) { // contents information
        if (indexPath.row == 0) {
            labelText = [NSString stringWithFormat:@"%d", _order.ordersByBottle.count];
            detailText = [NSString stringWithFormat:@"Bottles in this order"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            labelText = [NSString stringWithFormat:@"$%g", [Order totalAmountOfOrder:_order]];
            detailText = [NSString stringWithFormat:@"Total Amount"];
        }
    } else { // date picker
        _datePicker.date = _order.date ? _order.date : [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_datePicker];
    }
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = detailText;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) { // its the date picker section (only one row)
        return _datePicker.bounds.size.height;
    }
    return 44; // defaultl cell height
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 & indexPath.row == 0) { // its the "Bottles in Order" cell
        [self performSegueWithIdentifier:@"Show Bottles in Order Segue ID" sender:nil];
    } else if (indexPath.section == 0 & indexPath.row == 0) { // its the vendor, so present address book
        [self showPeoplePicker];
    }
    else {
        return;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) { // vendor
        return @"vendor";
    } else if (section == 1) { // contents
        return @"Order contents:";
    } else {
        return @"Order placed on:";
    }
}
#pragma Actions

// Delete order, pop controller
- (IBAction)didDeleteOrder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_managedObjectContext deleteObject:_order];
}

// Need to check the _order.vendor and see if its info is up to date with the contact address
// Also check if the order is complete
-(void)didSelectSendOrder {
    // First, check that the order is complete (has a vendor, has some bottles, etc.).
    NSString * error = [Order errorStringForSendingIncompleteOrder:_order];
    if (error) {
        UIAlertView * cantSendOrderAlertView = [[UIAlertView alloc] initWithTitle:@"Cannot send order because..." message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        cantSendOrderAlertView.tag = 1;
        [cantSendOrderAlertView show];
        return;
    }
    
    // Now see if Vendor is up to date with contact book
    BOOL vendorInfoIsCurrent = [Vendor updateVendorFromAddressBook:_order.whichVendor];
    if (vendorInfoIsCurrent) {   // Show mail view controller if vendor is current
        MFMailComposeViewController * mailTVC = [Order mailComposeForOrder:_order];
        mailTVC.mailComposeDelegate = self;
        [self presentViewController:mailTVC animated:YES completion:nil];
    } else {  // vendor is out of date, alert user to select a new vendor
        UIAlertView * vendorNotCurrentAlertView = [[UIAlertView alloc]initWithTitle:@"Vendor Is Not Current" message:@"The vendor is out of sync with your contact book.  Please select a new vendor." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pick Vendor", nil];
        vendorNotCurrentAlertView.tag = 2;
        [vendorNotCurrentAlertView show];
    }
}

#pragma Delegate methods

// mail composer
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// date picker
-(void)dateChanged {
    _order.date = _datePicker.date;
}

// Address picker
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    Vendor * vendor = [Vendor newVendorForRef:person inContext:_managedObjectContext];
    _order.whichVendor = vendor;

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

// Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 1) { // the "pick vendor" button
            [self showPeoplePicker];
        }
    }
}


#pragma utils

// Abstracted this because used in multiple places
-(void)showPeoplePicker {
    ABPeoplePickerNavigationController * peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}
@end
