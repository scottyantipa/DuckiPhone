//
//  PickBottleTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/16/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "PickBottleTableViewController.h"


@interface PickBottleTableViewController ()

@end

@implementation PickBottleTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;

- (void)viewDidLoad
{
    self.title = @"Pick Bottles";
    [super viewDidLoad];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // NOTE ---- THIS WILL EVENTUALLY NEEDED TO BE CUSTOM ORDERED
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"subType.name" cacheName:@"Master"];
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
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bottles to Pick CellID" forIndexPath:indexPath];
    cell.textLabel.text = bottle.name;
    NSSet * bottlesInOrder = _order.ordersByBottle;
    bool isSelected = NO;
    for (OrderForBottle * existingBottleOrder in bottlesInOrder) {
        if ([existingBottleOrder.whichBottle.name isEqualToString:[NSString stringWithFormat:@"%@", bottle.name]]) {
            isSelected = YES;
            break;
        } else {
            isSelected = NO;
        }
    }
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    bool isSelected = NO;
    NSSet * bottlesInOrder = _order.ordersByBottle;
    for (OrderForBottle * existingOrderForBottle in bottlesInOrder) {
        if ([existingOrderForBottle.whichBottle.name isEqualToString:[NSString stringWithFormat:@"%@", bottle.name]]) {
            isSelected = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_managedObjectContext deleteObject:existingOrderForBottle];
            break;
        } else {
            isSelected = NO;
        }
    }
    if (!isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [OrderForBottle newOrderForBottle:bottle forOrder:_order inManagedObjectContext:_managedObjectContext];
    }
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
