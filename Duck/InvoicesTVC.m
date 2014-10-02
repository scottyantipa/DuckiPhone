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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Invoice * invoice;
    if ([segue.identifier isEqualToString:@"Show Invoice From All Invoices"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        invoice = [_fetchedResultsController objectAtIndexPath:indexPath];
    } else if ([segue.identifier isEqualToString:@"Show New Invoice"]) {
        invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:_managedObjectContext];
        invoice.vendor = [Vendor newVendorInContext:_managedObjectContext];
    }
    [segue.destinationViewController setInvoice:invoice];
    [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateReceived" ascending:NO];
    
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
