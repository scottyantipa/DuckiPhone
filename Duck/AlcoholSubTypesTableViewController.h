//
//  AlcoholSubTypesTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "AlcoholType.h"
#import "BottlesForSubTypeTableViewController.h"
#import "VarietalsForSubTypeTVC.h"

@interface AlcoholSubTypesTableViewController : BaseCoreDataTableViewController
@property (strong, nonatomic) AlcoholType *parentType;
@property (strong, nonatomic) AlcoholSubType * selectedSubType;
@end
