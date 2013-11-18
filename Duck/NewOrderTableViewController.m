//
//  NewOrderTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "NewOrderTableViewController.h"

@interface NewOrderTableViewController ()

@end

@implementation NewOrderTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;


- (void)viewDidLoad
{
    self.title = @"New Order";
    [super viewDidLoad];

}

// We do this because the _order can be edited by
// a view before/after it
-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Bottles in Order Segue ID"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setOrder:_order];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // There will need to be 3 rows:  Bottles in Order, Date, Total Amount
    NSString * cellID = [NSString stringWithFormat:@"New Order CellID"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSString * labelText;
    NSString * detailText;
    if (indexPath.row == 0) {
        labelText = [NSString stringWithFormat:@"%d", _order.ordersByBottle.count];
        detailText = [NSString stringWithFormat:@"Bottles in this order"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 1) {
        labelText = [NSString stringWithFormat:@"$%g", [Order totalAmountOfOrder:_order]];
        detailText = [NSString stringWithFormat:@"Total Amount"];
    } else if (indexPath.row == 2) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        NSString * dateString = [dateFormatter stringFromDate:_order.date];
        labelText = [NSString stringWithFormat:@"%@", dateString];
        detailText = [NSString stringWithFormat:@"Date"];
    } else {
        labelText = [NSString stringWithFormat:@"ERROR"];
    }
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = detailText;
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // its the "Bottles in Order" cell
        [self performSegueWithIdentifier:@"Show Bottles in Order Segue ID" sender:nil];
    } else {
        return; // not working, all of the cells perform the segue above
    }
}
@end
