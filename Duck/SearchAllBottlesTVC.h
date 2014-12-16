//
//  SearchAllBottlesTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/15/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Utils.h"

@interface SearchAllBottlesTVC : UITableViewController
@property (strong, nonatomic) NSString * alcoholTypeToFilter;
@property (strong, nonatomic) UISegmentedControl * filterControl;
@property (strong, nonatomic) NSArray * foundObjects;
@end
