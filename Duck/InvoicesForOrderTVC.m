//
//  InvoicesTVC.m
//  Duck
//
//  Created by Scott Antipa on 9/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "InvoicesForOrderTVC.h"

@interface InvoicesForOrderTVC ()
@end

@implementation InvoicesForOrderTVC
@synthesize order = _order;
@synthesize invoicesArray = _invoicesArray;
@synthesize managedObjectContext = _managedObjectContext;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_invoicesArray count];
}

-(void)viewWillAppear:(BOOL)animated {
    _invoicesArray = [_order.invoices allObjects];
    [super viewWillAppear:animated];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Invoice Reuse ID" forIndexPath:indexPath];
    Invoice * invoice = [_invoicesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Number of photos: %d", invoice.photos.count];
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Invoice * invoice;
    if ([segue.identifier isEqualToString:@"Show Invoice From Invoices"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        invoice = [_invoicesArray objectAtIndex:indexPath.row];

    } else if ([segue.identifier isEqualToString:@"Show New Invoice"]) {
        invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:_managedObjectContext];
        invoice.order = _order;
    }
    [segue.destinationViewController setInvoice:invoice];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
