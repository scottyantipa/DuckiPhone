//
//  NewOrderTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order+Create.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Vendor+Create.h"
#import "EditVendorInfoViewController.h"
#import "CMPopTipViewStyleOverride.h"
#import "NSUserDefaultsManager.h"

@interface OrderTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, CMPopTipViewDelegate>
@property (strong, nonatomic) Order * order;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) CMPopTipViewStyleOverride * skusToolTip;
@end
