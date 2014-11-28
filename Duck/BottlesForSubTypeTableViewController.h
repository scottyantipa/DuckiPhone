//
//  BottlesForSubTypeTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "AlcoholSubTypesTableViewController.h"
#import "BottleDetailTableViewController.h"
#import "ToggleBottlesDelegate.h"
#import "ToggleBottlesTableViewController.h"
#import "BottleDetailDelegate.h"
#import "CMPopTipViewStyleOverride.h"
#import "Varietal.h"

@interface BottlesForSubTypeTableViewController : BaseCoreDataTableViewController <ToggleBottlesDelegate, BottleDetailDelegate, CMPopTipViewDelegate>
@property (strong, nonatomic) AlcoholSubType * subType;
@property (strong, nonatomic) Varietal * varietal;
@property (nonatomic) BOOL editing;
@property (strong, nonatomic) CMPopTipViewStyleOverride * plusButtonToolTip;
@end
