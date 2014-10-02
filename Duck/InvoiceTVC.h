//
//  InvoiceTVC.h
//  Duck
//
//  Created by Scott Antipa on 5/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "InvoicePhoto.h"
#import "Bottle+Create.h"
#import "Order+Create.h"
#import "InvoicePhotoVC.h"
#import "Vendor+Create.h"
#import "BottlesInInvoiceTVC.h"
#import "EditVendorInfoViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface InvoiceTVC : UITableViewController <UIImagePickerControllerDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) Invoice * invoice;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPhotoBarButton;
@property (weak, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) NSArray * sortedBottlesInOrder;
@property (weak, nonatomic) NSArray * sortedInvoicePhotos;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (nonatomic, strong) UIDatePicker * datePicker;
@end
