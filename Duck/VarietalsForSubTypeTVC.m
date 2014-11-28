//
//  VarietalsForSubTypeTVC.m
//  Duck
//
//  Created by Scott Antipa on 11/20/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "VarietalsForSubTypeTVC.h"

@interface VarietalsForSubTypeTVC ()

@end

@implementation VarietalsForSubTypeTVC
@synthesize subType = _subType;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    _managedObjectContext = _subType.managedObjectContext;
}

-(void)setSubType:(AlcoholSubType *)subType
{
    _subType = subType;
    self.title = subType.name;
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Varietal"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subType.name = %@", _subType.name, [NSNumber numberWithBool:YES]];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // in case no user ordering for the bottle
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"Varietals Cell" forIndexPath:indexPath];
    Varietal * varietal = (Varietal *)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = varietal.name;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Show Bottles For Varietal Segue ID"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Varietal * varietal = [_fetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController setVarietal:varietal];
    }
}

@end
