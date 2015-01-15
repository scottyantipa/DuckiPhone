//
//  AllMyBottlesTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/14/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Bottle+Create.h"
#import "WineBottle+Create.h"
#import "LiquorBottle.h"
#import "BeerBottle.h"
#import "Utils.h"
#import "MOCManager.h"
#import "SearchBottlesDelegate.h"
#import "SearchAllBottlesTVC.h"
#import "BottleInfoTableViewCell.h"
#import "BottleTVC.h"

@interface AllMyBottlesTVC : BaseCoreDataTableViewController <SearchBottlesDelegate>
@property (strong, nonatomic) NSString * alcoholTypeToFilter;
@property (strong, nonatomic) UISegmentedControl * filterControl;
@property (strong, nonatomic) Bottle * selectedBottle; // when user selects a bottle keep track of it for segue
@end
