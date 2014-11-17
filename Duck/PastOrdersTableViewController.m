//
//  PastOrdersTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "PastOrdersTableViewController.h"
#import "BottlesInOrderTableViewController.h"

@interface PastOrdersTableViewController ()

@end

@implementation PastOrdersTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize numberFormatter = _numberFormatter;
@synthesize dateFormatter = _dateFormatter;
@synthesize plusButtonToolTip = _plusButtonToolTip;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Your Orders";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_plusButtonToolTip != nil) {
        [_plusButtonToolTip dismissAnimated:YES];
        _plusButtonToolTip = nil;
    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_fetchedResultsController.fetchedObjects.count == 0) {
        [self showHint];
    }
}


-(void)showHint {
    _plusButtonToolTip = [[CMPopTipViewStyleOverride alloc] initWithMessage:@"Log your first order"];
    _plusButtonToolTip.delegate = self;
    [CMPopTipViewStyleOverride setStylesForPopup:_plusButtonToolTip];
    UIBarButtonItem * addButton = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
    [_plusButtonToolTip presentPointingAtBarButtonItem:addButton animated:YES];
}

#pragma Delegate methods for tool tip
-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self performSegueWithIdentifier:@"Show New Order" sender:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_plusButtonToolTip != nil) {
        [_plusButtonToolTip dismissAnimated:YES];
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Past Orders Reuse ID" forIndexPath:indexPath];
    Order * order = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString * dateString = [_dateFormatter stringFromDate:order.date];
    cell.textLabel.text = [Order description:order withNumForatter:_numberFormatter];
    cell.detailTextLabel.text = dateString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OrderTableViewController * tvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Show New Order"]) {
        tvc.order = [Order newOrderForDate:[NSDate date] inManagedObjectContext:_managedObjectContext];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Order * order = [self.fetchedResultsController objectAtIndexPath:indexPath];
        tvc.order = order;
    }
    [tvc setManagedObjectContext:_managedObjectContext];
}



@end
