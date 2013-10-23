//
//  NewOrderTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/16/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BottlesInOrderTableViewController.h"
#import "PickBottleTableViewController.h"
#import "Bottle+Create.h"
#import "EditOrderForBottleDetailsViewController.h"

@interface BottlesInOrderTableViewController ()

@end

@implementation BottlesInOrderTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;

- (void)viewDidLoad
{
    self.title = @"Bottles in Order";
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)setOrder:(Order *)order {
    _order = order;
}

-(NSArray *)getSortedBottlesInOrder {
    NSSet * bottlesInOrder = _order.ordersByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whichBottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
   return [bottlesInOrder sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSSet * bottlesInOrder = _order.ordersByBottle;
    return [bottlesInOrder count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bottles in New Order CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray * sortedBottleOrders = [Order getSortedBottlesInOrder:_order];
    OrderForBottle * orderForBottle = [sortedBottleOrders objectAtIndex:indexPath.row];
    cell.textLabel.text = orderForBottle.whichBottle.name;
    NSMutableString * priceStr = [NSMutableString stringWithFormat:@"Enter Price"];
    if (orderForBottle.unitPrice) {
        priceStr = [NSMutableString stringWithFormat:@"$%@/unit", orderForBottle.unitPrice];
    }
    NSMutableString * quantityStr = [NSMutableString stringWithFormat:@"Enter Quantity"];
    if (orderForBottle.quantity) {
        quantityStr = [NSMutableString stringWithFormat:@"%@ units", orderForBottle.quantity];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", quantityStr, priceStr];
    
    return cell;
}


#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Bottles to Pick Segue ID"]) {
        PickBottleTableViewController * tvc = [segue destinationViewController];
        [tvc setManagedObjectContext:_managedObjectContext];
        [tvc setOrder:_order];
    } else if ([segue.identifier isEqualToString:@"Edit Order For Bottle Segue ID"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray * sortedBottleOrders = [Order getSortedBottlesInOrder:_order];
        OrderForBottle * orderForBottle = [sortedBottleOrders objectAtIndex:indexPath.row];
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setOrderForBottle:orderForBottle];
    }
}

@end
