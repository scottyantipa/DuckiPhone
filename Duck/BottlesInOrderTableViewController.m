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
@synthesize sortedBottlesInOrder = _sortedBottlesInOrder;

- (void)viewDidLoad
{
    self.title = @"Bottles in Order";
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    NSSet * bottlesInOrder = _order.ordersByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whichBottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    _sortedBottlesInOrder = [bottlesInOrder sortedArrayUsingDescriptors:sortDescriptors];
}

-(void)setOrder:(Order *)order {
    _order = order;
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
    
    OrderForBottle * orderForBottle = [_sortedBottlesInOrder objectAtIndex:indexPath.row];
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

-(IBAction)didTouchReOrderButton:(id)sender
{
    // Create a mail view controller to order from the vendor
    // Will need to iterate through each bottle snapshot and produce a string
    // Use the order.whichVendor to get email, name, etc.
    NSString * vendorName = _order.whichVendor.name;
    NSString * greeting = [NSString stringWithFormat:@"Hello %@,\n\nI would like to place an order with you as described below:", vendorName];
    
    NSMutableArray * bottleStrings = [[NSMutableArray alloc] init];
    for (OrderForBottle * orderForBottle in _sortedBottlesInOrder) {
        // Create the string for this bottle order (bottle name, price, quantity)
        NSString * name = [NSString stringWithFormat:@"Bottle: %@", orderForBottle.whichBottle.name];
        NSString * quantity = [NSString stringWithFormat:@"Qty: %g", [orderForBottle.quantity floatValue]];
        NSString * price = [NSString stringWithFormat:@"Unit Price: %g", [orderForBottle.unitPrice floatValue]];
        NSString * blockForBottle = [NSString stringWithFormat:@"%@\n%@\n%@", name, quantity, price];
        
        [bottleStrings addObject:blockForBottle];
    }
    
    NSString * allBottles = [bottleStrings componentsJoinedByString:@"\n\n"];
    NSString * signOff = [NSString stringWithFormat:@"Thank you. \n\nPowered by Duck Rows"];
    
    NSString * body = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", greeting, allBottles, signOff];
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"New Order"];
    [mailViewController setMessageBody:body isHTML:NO];
    [self presentViewController:mailViewController animated:YES completion:nil];
}

@end
