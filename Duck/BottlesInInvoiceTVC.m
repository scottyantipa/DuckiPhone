//
//  BottlesInInvoiceTVC.m
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BottlesInInvoiceTVC.h"

@interface BottlesInInvoiceTVC ()
@end

@implementation BottlesInInvoiceTVC
@synthesize managedObjectContext = _managedObjectContext;
@synthesize invoice = _invoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bottles in Invoice";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self reload];
}

-(void)reload{
    NSSet * invoicesByBottle = _invoice.invoicesByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    _sortedInvoicesByBottle = [invoicesByBottle sortedArrayUsingDescriptors:sortDescriptors];
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_invoice.invoicesByBottle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Invoices By Bottle CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    InvoiceForBottle * invoiceForBottle = [_sortedInvoicesByBottle objectAtIndex:indexPath.row];
    cell.textLabel.text = invoiceForBottle.bottle.name;
    NSMutableString * priceStr = [NSMutableString stringWithFormat:@"Enter Price"];
    if (invoiceForBottle.unitPrice) {
        NSString * price = [_numberFormatter stringFromNumber:invoiceForBottle.unitPrice];
        priceStr = [NSMutableString stringWithFormat:@"%@/unit", price];
    }
    NSMutableString * quantityStr = [NSMutableString stringWithFormat:@"Enter Quantity"];
    if (invoiceForBottle.quantity) {
        quantityStr = [NSMutableString stringWithFormat:@"%@ units", invoiceForBottle.quantity];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", quantityStr, priceStr];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Pick Bottles For Invoice"]) {
        ToggleBottlesTableViewController * tvc = [segue destinationViewController];
        tvc.delegate = self;
        tvc.managedObjectContext = _managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"Edit Price And Quantity of Bottle Invoice"]){
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        InvoiceForBottle * invoice = [_sortedInvoicesByBottle objectAtIndex:indexPath.row];
        EditPriceAndQtyVC * vc = segue.destinationViewController;
        [vc setManagedObjectContext:_managedObjectContext];
        [vc setManagedObject:invoice];
        vc.delegate = self;
    }
}

#pragma Delegate parent methods for toggle bottles

-(void)didSelectBottle:(Bottle *)bottle {
    [Invoice toggleBottle:bottle inInvoice:_invoice inContext:_managedObjectContext];
    [self reload];
}


// Iterate over the bottles in the order to find that orderForBottle
-(BOOL)bottleIsSelected:(Bottle *)bottle {
    NSSet * invoicesByBottle = _invoice.invoicesByBottle;
    BOOL bottleIsSelected = NO; // by default
    for (InvoiceForBottle * invoice in invoicesByBottle) {
        if (bottle == invoice.bottle) {
            bottleIsSelected = YES;
            break;
        }
    }
    return bottleIsSelected;
}

#pragma Delegate methods for edit price and quantity

-(void)didFinishEditingPrice:(NSNumber *)price forObject:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    invoiceForBottle.unitPrice = price;
}
-(NSNumber *)priceOfObj:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    return invoiceForBottle.unitPrice;
}

-(void)didFinishEditingQuantity:(NSNumber *)qty forObject:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    invoiceForBottle.quantity = qty;
}
-(NSNumber *)quantityOfObj:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    return invoiceForBottle.quantity;
}

-(NSString *)nameOfObject:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    return invoiceForBottle.bottle.name;
}


@end
