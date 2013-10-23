//
//  NewOrderTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order+Create.h"

@interface NewOrderTableViewController : UITableViewController
@property (strong, nonatomic) Order * order;
@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@end
