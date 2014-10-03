//
//  PickOrderTVC.m
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "PickOrderTVC.h"

@interface PickOrderTVC ()
@end

@implementation PickOrderTVC

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize numberFormatter = _numberFormatter;
- (void)viewDidLoad {
    self.title = @"Pick Order";
    [super viewDidLoad];
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Order"];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // NOTE ---- THIS WILL EVENTUALLY NEEDED TO BE CUSTOM ORDERED
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell for pick order" forIndexPath:indexPath];
    Order * order = [_fetchedResultsController objectAtIndexPath:indexPath];
    BOOL selected = [self.delegate orderIsSelected:order];
    if (selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [Order description:order withNumForatter:_numberFormatter];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Order * order = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate didSelectOrder:order];
}




@end
