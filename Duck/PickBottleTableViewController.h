//
//  PickBottleTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/16/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Order+Create.h"
#import "OrderForBottle+Create.h"
#import "Bottle+Create.h"

@interface PickBottleTableViewController : BaseCoreDataTableViewController
@property (strong, nonatomic) Order * order;
@end
