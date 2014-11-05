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
#import "StandardModalDelegate.h"

@interface BottlesForSubTypeTableViewController : BaseCoreDataTableViewController <ToggleBottlesDelegate, StandardModalDelegate>
@property (strong, nonatomic) AlcoholSubType *subType;
@property (nonatomic) BOOL editing;
@end
