//
//  BottlesForSubTypeTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "AlcoholSubTypesTableViewController.h"

@interface BottlesForSubTypeTableViewController : BaseCoreDataTableViewController
@property (strong, nonatomic) AlcoholSubType *subType;
@end
