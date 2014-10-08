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
#import "EditPriceAndQtyVC.h"

@interface BottlesInOrderTableViewController ()
@end

@implementation BottlesInOrderTableViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;
@synthesize sortedBottlesInOrder = _sortedBottlesInOrder;
@synthesize numberFormatter = _numberFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bottles in Order";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

}

-(void)viewWillAppear:(BOOL)animated {
    [self reload];
}

-(void)reload{
    _sortedBottlesInOrder = [Order getSortedBottlesInOrder:_order];
    [[self tableView] reloadData];
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
    return [_order.ordersByBottle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bottles in New Order CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    OrderForBottle * orderForBottle = [_sortedBottlesInOrder objectAtIndex:indexPath.row];
    cell.textLabel.text = orderForBottle.whichBottle.name;
    NSMutableString * priceStr = [NSMutableString stringWithFormat:@"Enter Price"];
    if (orderForBottle.unitPrice) {
        NSString * price = [_numberFormatter stringFromNumber:orderForBottle.unitPrice];
        priceStr = [NSMutableString stringWithFormat:@"%@/unit", price];
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
    if ([segue.identifier isEqualToString:@"Toggle Bottles in Order Segue ID"]) {
        ToggleBottlesTableViewController * tvc = [segue destinationViewController];
        tvc.delegate = self;
        tvc.managedObjectContext = _managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"Edit Order For Bottle Segue ID"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray * sortedBottleOrders = [Order getSortedBottlesInOrder:_order];
        OrderForBottle * orderForBottle = [sortedBottleOrders objectAtIndex:indexPath.row];
        
        EditPriceAndQtyVC * vc = segue.destinationViewController;
        [vc setManagedObjectContext:_managedObjectContext];
        [vc setManagedObject:orderForBottle];
        vc.delegate = self;
    }
}


#pragma Delegate parent methods for toggle bottles

-(void)didSelectBottle:(Bottle *)bottle {
    [Order toggleBottle:bottle inOrder:_order inContext:_managedObjectContext];
    [self reload];
}



// Iterate over the bottles in the order to find that orderForBottle
-(BOOL)bottleIsSelected:(Bottle *)bottle {
    NSSet * orders = _order.ordersByBottle;
    BOOL bottleIsSelected = NO; // by default
    for (OrderForBottle * orderForBottle in orders) {
        Bottle * bottleForOrder = orderForBottle.whichBottle;
        if (bottleForOrder == bottle) {
            bottleIsSelected = YES;
            break;
        }
    }
    return bottleIsSelected;
}

#pragma Delegate methods for edit price and quantity
-(void)didFinishEditingPrice:(NSNumber *)price andQuantity:(NSNumber *)quantity forObject:(id)obj {
    OrderForBottle * orderForBottle = (OrderForBottle *)obj;
    orderForBottle.quantity = quantity;
    orderForBottle.unitPrice = price;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(NSNumber *)priceOfObj:(id)obj {
    OrderForBottle * orderForBottle = (OrderForBottle *)obj;
    return orderForBottle.unitPrice;
}


-(NSNumber *)quantityOfObj:(id)obj {
    OrderForBottle * orderForBottle = (OrderForBottle *)obj;
    return orderForBottle.quantity;
}

-(NSString *)nameOfObject:(id)obj {
    OrderForBottle * orderForBottle = (OrderForBottle *)obj;
    return orderForBottle.whichBottle.name;
}

@end
