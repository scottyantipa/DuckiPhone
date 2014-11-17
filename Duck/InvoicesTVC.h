//
//  InvoicesTVC.h
//  Duck
//
//  Created by Scott Antipa on 9/29/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Invoice.h"
#import "InvoiceTVC.h"
#import "Vendor+Create.h"
#import "CMPopTipViewStyleOverride.h"

@interface InvoicesTVC : BaseCoreDataTableViewController <CMPopTipViewDelegate>
@property (strong, nonatomic) CMPopTipViewStyleOverride * plusButtonToolTip;
@end
