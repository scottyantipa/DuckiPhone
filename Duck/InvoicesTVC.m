//
//  InvoicesTVC.m
//  Duck
//
//  Created by Scott Antipa on 9/29/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "InvoicesTVC.h"

@interface InvoicesTVC ()

@end

@implementation InvoicesTVC
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All Invoices";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dataReceived" ascending:NO];
    
    NSArray * sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController * aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    NSError * error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"All Invoices Cell Reuse ID"];
    Invoice * invoice = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", invoice.photos.count];
    return cell;
}

@end
