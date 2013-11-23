//
//  ToggleBottlesTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 11/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "ToggleBottlesTableViewController.h"
#import "AlcoholSubType+Create.h"

@interface ToggleBottlesTableViewController ()

@end

@implementation ToggleBottlesTableViewController
// why do I have to synthesize these here, as well as in the parent class?
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

// Controller should show all bottles organized by subType, sorted by userOrdering/userHasBottle/name
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"subType.name" ascending:NO];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray * sortDescriptors = @[sortDescriptor1, sortDescriptor2];
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"All Bottles to Toggle Cell ID" forIndexPath:indexPath];
    cell.textLabel.text = bottle.name;
    if ([self.delegate bottleIsSelected:bottle]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// Toggle if the user has/doesnt have the bottle
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate didSelectBottle:bottle];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
