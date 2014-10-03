//
//  PastOrdersTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Order+Create.h"
#import "OrderTableViewController.h"

@interface PastOrdersTableViewController : BaseCoreDataTableViewController
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@end
