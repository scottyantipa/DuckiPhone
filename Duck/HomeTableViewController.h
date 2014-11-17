//
//  HomeTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 8/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Bottle+Create.h"
#import "BottleDetailTableViewController.h"
#import "OrderTableViewController.h"
#import "Order+Create.h"
#import "PastOrdersTableViewController.h"
#import <UIKit/UIKit.h>
#import "BottleDetailDelegate.h"
#import "TakeInventoryTVC.h"
#import "SingleBarcodeScanner.h"
#import "SingleBarcodeScannerDelegate.h"
#import "CMPopTipViewStyleOverride.h"
#import "NSUserDefaultsManager.h"

@interface HomeTableViewController : UITableViewController <UIAlertViewDelegate, BottleDetailDelegate, SingleBarcodeScannerDelegate, CMPopTipViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property  (strong, nonatomic) NSString *currentScannedBottleBarcode;
@property (strong, nonatomic) Bottle * mostRecentFoundBottle;
@property (strong, nonatomic) CMPopTipViewStyleOverride * myBottlesToolTip;
@end