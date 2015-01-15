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
#import "SearchBottlesDelegate.h"
#import "BottleInfoTableViewCell.h"

@interface SearchAllBottlesTVC : UITableViewController
@property (strong, nonatomic) NSString * alcoholTypeToFilter;
@property (strong, nonatomic) UISegmentedControl * filterControl;
@property (strong, nonatomic) NSMutableArray * fetchedBottles; // array of managed objects fetched/written from server
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) Bottle * selectedBottle; // an actual Bottle or WineBottle, LiquorBottle, etc found from selectedBottleObject;
@property id <SearchBottlesDelegate> delegate;
@end
