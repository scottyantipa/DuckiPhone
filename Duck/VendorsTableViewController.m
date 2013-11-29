//
//  VendorsTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 11/26/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "VendorsTableViewController.h"

@interface VendorsTableViewController ()

@end

@implementation VendorsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Vendor"];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // For Testing...
    //    NSError *err;
    //    NSArray *fetchedObjects = [self.parentType.managedObjectContext executeFetchRequest:fetchRequest error:&err];
    //    NSLog(@"Count of subtypes: %d", fetchedObjects.count);
    //    for (AlcoholSubType *subType in fetchedObjects) {
    //        NSLog(@"SubType Name: %@", subType.name);
    //    }
    
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

- (void)viewDidLoad
{
    self.title = @"Vendors";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Vendor TVC Cell Reuse ID"];
    Vendor * vendor = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [Vendor fullNameOfVendor:vendor];
    return cell;
}

@end
