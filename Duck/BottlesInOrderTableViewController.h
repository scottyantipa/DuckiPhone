//
//  NewOrderTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/16/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order+Create.h"
#import "Vendor.h"
#import "ToggleBottlesDelegate.h"
#import "ToggleBottlesTableViewController.h"
#import "EditPriceAndQuantityDelegate.h"
#import "EditPriceAndQtyVC.h"

@interface BottlesInOrderTableViewController : UITableViewController <ToggleBottlesDelegate, EditPriceAndQuantityDelegate>
@property (strong, nonatomic) Order * order;
@property (nonatomic, strong) NSArray * sortedBottlesInOrder;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@end
