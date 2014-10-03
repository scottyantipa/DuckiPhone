//
//  LossesTVC.h
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bottle+Create.h"
#import "Invoice+Create.h"
#import "InvoiceForBottle.h"

@interface LossesTVC : UITableViewController
@property (weak) NSDate * startDate;
@property (strong, nonatomic) NSArray * userBottles;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@end
