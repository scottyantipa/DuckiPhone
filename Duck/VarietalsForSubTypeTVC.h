//
//  VarietalsForSubTypeTVC.h
//  Duck
//
//  Created by Scott Antipa on 11/20/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "AlcoholSubType+Create.h"
#import "Varietal.h"

@interface VarietalsForSubTypeTVC : BaseCoreDataTableViewController
@property (strong, nonatomic) AlcoholSubType * subType;
@end
