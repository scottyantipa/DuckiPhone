//
//  PickOrderTVC.h
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "PickOrderDelegate.h"
#import "Order+Create.h"

@interface PickOrderTVC : BaseCoreDataTableViewController
@property (weak) id <PickOrderDelegate> delegate;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@end