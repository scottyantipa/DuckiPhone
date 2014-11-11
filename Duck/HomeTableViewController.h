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
#import "ZBarSDK.h"
#import "BottleDetailDelegate.h"
#import "TakeInventoryTVC.h"

@interface HomeTableViewController : UITableViewController <ZBarReaderDelegate, UIAlertViewDelegate, BottleDetailDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property  (strong, nonatomic) NSString *currentScannedBottleBarcode;
@property (strong, nonatomic) Bottle * mostRecentFoundBottle;
@end