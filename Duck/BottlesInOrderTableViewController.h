//
//  NewOrderTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/16/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Order+Create.h"
#import "Vendor.h"

@interface BottlesInOrderTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) Order * order;
@property (nonatomic, strong) NSArray * sortedBottlesInOrder;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end
