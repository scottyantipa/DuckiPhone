//
//  InvoicesTVC.h
//  Duck
//
//  Created by Scott Antipa on 9/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order+Create.h"
#import "Invoice.h"

@interface InvoicesTVC : UITableViewController
@property (weak, nonatomic) NSArray * invoicesArray;
@property (weak, nonatomic) Order * order;
@property (weak, nonatomic) NSManagedObjectContext * managedObjectContext;
@end
