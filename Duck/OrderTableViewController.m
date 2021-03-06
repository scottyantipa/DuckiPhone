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
@synthesize order = _order;
@synthesize datePicker = _datePicker;
@synthesize numberFormatter = _numberFormatter;
@synthesize addressBook = _addressBook;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize skusToolTip = _skusToolTip;

// Lazy instantiate an order if there isn't one.  If there is an order, add affordance
// to Re-order from the vendor.  Also intialize class vars -- order, datePicker
- (void)viewDidLoad
{
    [super viewDidLoad];
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    _datePicker = [[UIDatePicker alloc] init];
    
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (!_order) { // this is a new order to display
        _order = [Order newOrderForDate:[NSDate date] inManagedObjectContext:_managedObjectContext];
    }
    [self setHeader];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_skusToolTip != nil) {
        [_skusToolTip dismissAnimated:YES];
        _skusToolTip = nil;
    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([NSUserDefaultsManager isFirstTimeShowingClass:NSStringFromClass([self class])]) {
        [self showHint];
    }
}


-(void)showHint {
    _skusToolTip = [[CMPopTipViewStyleOverride alloc] initWithMessage:@"Select which bottles you would like to order"];
    _skusToolTip.delegate = self;
    [CMPopTipViewStyleOverride setStylesForPopup:_skusToolTip];
    NSIndexPath * skusPath = [NSIndexPath indexPathForItem:0 inSection:1];
    UITableViewCell * skusCell = [self.tableView cellForRowAtIndexPath:skusPath];
    [_skusToolTip presentPointingAtView:skusCell inView:self.view animated:YES];
}

#pragma Delegate methods for tool tip
-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self performSegueWithIdentifier:@"Show Bottles in Order Segue ID" sender:nil];
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_skusToolTip != nil) {
        [_skusToolTip dismissAnimated:YES];
    }
}

-(void)reloadAll {
    [self.tableView reloadData];
    [self setHeader];
}

// create button to order from vendor or duplicate order
-(void)setHeader {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int reOrderButtonHeight = 35;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, reOrderButtonHeight)];
    UIButton * orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    if ([_order.sent isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [orderButton addTarget:self action:@selector(didSelectDuplicate) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setTitle:@"Duplicate this Order" forState:UIControlStateNormal];
    } else {
        [orderButton addTarget:self action:@selector(didSelectSendOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setTitle:@"Send Order to Vendor" forState:UIControlStateNormal];
    }

    orderButton.frame = CGRectMake(0, 15, screenWidth, reOrderButtonHeight);
    [headerView addSubview:orderButton];
    self.tableView.tableHeaderView = headerView;
    self.title = @"Order";
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Bottles in Order Segue ID"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setOrder:_order];
    } else if ([segue.identifier isEqualToString:@"Show Vendor Contact Info Segue ID"]) {
        [segue.destinationViewController setVendor:_order.whichVendor];
    } else if ([segue.identifier isEqualToString:@"Show Invoices from OrderTVC"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setOrder:_order];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5; // Vendor, status, bottles, invoices, date
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 2; // "status" section has sent/arrived cells
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = [NSString stringWithFormat:@"New Order CellID"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSString * labelText;
    NSString * detailText;
    NSString * noNameText = @"No name";
    
    if (indexPath.section == 0) { // vendor
        Vendor * vendor = _order.whichVendor;
        NSString * vendorName = [Vendor fullNameOfVendor:vendor];
        labelText = vendorName ? vendorName : noNameText;
        detailText = vendor.email ? vendor.email : @"No Email";
    } else if (indexPath.section == 1) { // bottles
        NSString * price = [_numberFormatter stringFromNumber:[NSNumber numberWithFloat:[Order totalAmountOfOrder:_order]]];
        labelText = [NSString stringWithFormat:@"%d skus totalling %@", _order.ordersByBottle.count, price];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // for both the sku and the invoices
    } else if (indexPath.section == 2) {
        labelText = @"Invoices";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // for both the sku and the invoices
    }
    else if (indexPath.section == 3) { // status section
        if (indexPath.row == 0) { // orderSent Switch
            labelText = @"Order Sent";
            UISwitch * orderSentSwitch = [[UISwitch alloc]init];
            orderSentSwitch.tag = 1;
            [orderSentSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            BOOL sent = [_order.sent isEqualToNumber:[NSNumber numberWithBool:YES]];
            [orderSentSwitch setOn:sent]; // CHANGE TO _order.sent
            cell.accessoryView = [[UIView alloc]initWithFrame:orderSentSwitch.frame];
            [cell.accessoryView addSubview:orderSentSwitch];
        } else if (indexPath.row == 1) { // orderArrived Switch
            labelText = @"Order Arrived";
            UISwitch * orderArrivedSwitch = [[UISwitch alloc]init];
            orderArrivedSwitch.tag = 2;
            [orderArrivedSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            BOOL arrived = [_order.arrived isEqualToNumber:[NSNumber numberWithBool:YES]];
            [orderArrivedSwitch setOn:arrived]; // CHANGE TO _order.arrived
            cell.accessoryView = [[UIView alloc]initWithFrame:orderArrivedSwitch.frame];
            [cell.accessoryView addSubview:orderArrivedSwitch];
        }

    } else { // date picker
        _datePicker.date = _order.date ? _order.date : [NSDate date];
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_datePicker];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = detailText;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) { // its the date picker section (only one row)
        return _datePicker.bounds.size.height;
    }
    return 44; // defaultl cell height
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self alertForPickingManualOrFromAddressBook:@"Pick vendor from address book, or enter manually?"];
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"Show Bottles in Order Segue ID" sender:nil];
    } else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"Show Invoices from OrderTVC" sender:nil];
    }
    else {
        return;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) { // vendor
        return @"vendor";
    } else if (section == 1) { // contents
        return @"skus to order";
    } else if (section == 3) { // status
        return @"status";
    } else if (section == 4) { // date
        return @"date ordered";
    } else {
        return @"";
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
        [cantSendOrderAlertView show];
        return;
    }
    
    MFMailComposeViewController * mailTVC = [Order mailComposeForOrder:_order];
    mailTVC.mailComposeDelegate = self;
    [self presentViewController:mailTVC animated:YES completion:nil];
}

// User wants to duplicate the order.  We will create a new Order
// and show it using this same TVC (with an alert to let the user know it was switched in)
-(void)didSelectDuplicate {
    // create a duplicate order
    Order * duplicateOrder = [Order makeDuplicate:_order inContext:_managedObjectContext];
    self.order = duplicateOrder;
    [self reloadAll];
    
    // alert user that the view has changed
    UIAlertView * alertDuplicateIsShowing = [[UIAlertView alloc]initWithTitle:@"Successfully Duplicated Order" message:@"The order now being shown is the new duplicate" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDuplicateIsShowing show];
}

#pragma Delegate methods

// mail composer
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultFailed) {
        UIAlertView * failedMailAlertView = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"We are not sure what caused the failure" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [failedMailAlertView show];
        return;
    } else if (result == MFMailComposeResultSent) { // the message was sent successfully
        _order.sent = [NSNumber numberWithBool:YES];
        [self reloadAll];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// date picker
-(void)dateChanged {
    _order.date = _datePicker.date;
}


-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    Vendor * vendor = [Vendor newVendorForRef:person inContext:_managedObjectContext];
    _order.whichVendor = vendor;
    [self.tableView reloadData];
    [self.view setNeedsDisplay]; // had rendering issues with table cell, hopefully this keeps it fixed
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Address picker
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Switch NOTE: It would be nice to abstract this data logic into a data object like Order
-(void)switchChanged:(id)sender {
    UISwitch * theSwitch = sender;
    NSNumber * isOn = [NSNumber numberWithBool:[theSwitch isOn]];
    if (theSwitch.tag == 1) {
        _order.sent = isOn;
    } else if (theSwitch.tag == 2) {
        _order.arrived = isOn;
    }
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [self setHeader];
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



@end
