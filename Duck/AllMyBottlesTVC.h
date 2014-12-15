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

@interface AllMyBottlesTVC : BaseCoreDataTableViewController
@property (strong, nonatomic) NSString * alcoholTypeToFilter;
@property (strong, nonatomic) UISegmentedControl * filterControl;
@end
