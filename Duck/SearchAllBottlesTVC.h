//
//  SearchAllBottlesTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/15/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import <Parse/Parse.h>
#import "Bottle+Create.h"
#import "MOCManager.h"
#import "BottleTVC.h"

@interface SearchAllBottlesTVC : UITableViewController
@property (strong, nonatomic) NSString * alcoholTypeToFilter;
@property (strong, nonatomic) UISegmentedControl * filterControl;
@property (strong, nonatomic) NSArray * foundObjects;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@end
