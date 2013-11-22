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

// Fetch all bottles
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
    if (bottle.userHasBottle == [NSNumber numberWithInt:1]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// Toggle if the user has/doesnt have the bottle
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString * subTypeName = bottle.subType.name;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    
    // Fetch the bottles that the user has.  We will adjust their userOrdering when the user
    // adds/removes a bottle
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subType.name = %@) AND (self.userHasBottle = %@)", subTypeName, [NSNumber numberWithBool:YES]];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *err;
    NSArray * fetchedBottles = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    if (bottle.userHasBottle == [NSNumber numberWithInt:1]) { // user did have bottle
        bottle.userHasBottle = [NSNumber numberWithBool:NO];
        int order = [bottle.userOrdering intValue];
        for (Bottle * otherBottle in fetchedBottles) {
            if (otherBottle.name == bottle.name) {
                continue;
            }
            int oldOrderForOtherBottle = [otherBottle.userOrdering intValue];
            NSNumber * newOrderForOtherBottle;
            if (order < oldOrderForOtherBottle) { // removed bottle was before this bottle
                newOrderForOtherBottle = [NSNumber numberWithInt:(oldOrderForOtherBottle - 1)];
                otherBottle.userOrdering = newOrderForOtherBottle;
            } else {
                continue; // removed bottle was after this bottle, so no change to the order
            }
        }
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    } else { // user did not have bottle so lets add it to the end
        bottle.userHasBottle = [NSNumber numberWithBool:YES];
        NSUInteger newOrder = [fetchedBottles count];
        int newOrderInt = (int)newOrder;
        bottle.userOrdering = [NSNumber numberWithInteger:(newOrderInt)];
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
