//
//  TakeInventoryTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/5/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTableViewController.h"
#import "Bottle+Create.h"
#import "InventorySnapshotForBottle+Create.h"
#import "EditManagedObjCountViewController.h"

@interface TakeInventoryTableViewController ()

@end

@implementation TakeInventoryTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(userHasBottle = %@)", [NSNumber numberWithBool:YES]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"subType.name" ascending:NO];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Take Inventory CellID" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = bottle.name;
    NSNumber * bottleCount = [Bottle countOfBottle:bottle forContext:_managedObjectContext];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", bottleCount.floatValue];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    EditManagedObjCountViewController * editObjVC = segue.destinationViewController;
    [editObjVC setManagedObj:bottle];
    editObjVC.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma Protocal Methods

// Note that the returned count better be a valid number
-(void)didFinishEditingCount:(NSNumber *)count forObject:(id)obj {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:count forBottle:obj inManagedObjectContext:_managedObjectContext];
    [self.tableView reloadData];
}

-(float)countOfManagedObject:(id)obj {
    NSNumber * num = [Bottle countOfBottle:obj forContext:_managedObjectContext];
    float countAsFloat = [num floatValue];
    return countAsFloat;
}


@end
