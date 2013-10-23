//
//  BottlesForSubTypeTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BottlesForSubTypeTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType.h"
#import "BottleDetailTableViewController.h"

@interface BottlesForSubTypeTableViewController ()

@end

@implementation BottlesForSubTypeTableViewController
@synthesize subType = _subType;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void)setSubType:(AlcoholSubType *)subType
{
    _subType = subType;
    self.title = subType.name;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subType.name = %@", self.subType.name];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // get the results and print them
//    NSError *err;
//    NSArray *fetchedObjects = [self.subType.managedObjectContext executeFetchRequest:fetchRequest error:&err];
//    for (Bottle *bottle in fetchedObjects) {
//        NSLog(@"Botle Name: %@", bottle.name);
//    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.subType.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle SubTypes CellID" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Bottle *bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = bottle.name;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Bottle *bottle = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.destinationViewController respondsToSelector:@selector(setBottleInfo:)]) {
        [segue.destinationViewController setBottleInfo:bottle];
        [segue.destinationViewController setManagedObjectContext:self.subType.managedObjectContext];
    }
}

-(void)viewDidUnload
{
    self.fetchedResultsController = nil;
}


@end
