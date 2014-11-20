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
@synthesize mostRecentInvoiceForBottleAdded = _mostRecentInvoiceForBottleAdded;
@synthesize noOrderForBottles = _noOrderForBottles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bottles in Invoice";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    _noOrderForBottles = [[NSMutableDictionary alloc] init];
    [self setHeader];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self reload];
}

const float HEADER_HEIGHT = 30;

// notify user if there are bottles they have never ordered
-(void)setHeader {
    if (_noOrderForBottles.count == 0) {
        return;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, HEADER_HEIGHT)];
    

    int labelWidth = screenWidth - 40;
    UILabel * alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, labelWidth, HEADER_HEIGHT)];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
    alertLabel.numberOfLines = 0;
    [alertLabel setFont:[UIFont systemFontOfSize:12.0]];
    alertLabel.text = [NSString stringWithFormat:@"Bottles in red have not been ordered before"];
    alertLabel.textColor = [UIColor redColor];
    [headerView addSubview:alertLabel];

    self.tableView.tableHeaderView = headerView;
}

-(void)reload{
    NSSet * invoicesByBottle = _invoice.invoicesByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    _sortedInvoicesByBottle = [invoicesByBottle sortedArrayUsingDescriptors:sortDescriptors];

    // set the dict of bottles which don't have any previous orders
    _noOrderForBottles = [[NSMutableDictionary alloc] init];
    for (InvoiceForBottle * bottleInvoice in _sortedInvoicesByBottle) {
        OrderForBottle * orderForBottle = [Bottle mostRecentOrderForBottle:bottleInvoice.bottle inContext:_managedObjectContext];
        if (orderForBottle == nil) {
            [_noOrderForBottles setObject:bottleInvoice.bottle forKey:bottleInvoice.bottle.barcode];
        }
    }
    [self setHeader];
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
    
    // see if it has any previous orders and if not, make it red background
    if ([_noOrderForBottles objectForKey:invoiceForBottle.bottle.barcode] != nil) {
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Toggle Bottles in Invoice"]) {
        ToggleBottlesTableViewController * tvc = [segue destinationViewController];
        tvc.delegate = self;
        tvc.managedObjectContext = _managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"Show Edit Price and Quantity From Invoice"]){
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        InvoiceForBottle * invoice = [_sortedInvoicesByBottle objectAtIndex:indexPath.row];
        EditPriceAndQtyVC * vc = segue.destinationViewController;
        [vc setManagedObjectContext:_managedObjectContext];
        [vc setManagedObject:invoice];
        vc.delegate = self;
    }
}

#pragma Delegate parent methods for toggle bottles

-(void)didSelectBottleWithId:(NSManagedObjectID *)bottleID
{
    if (bottleID != nil) {
        Bottle * bottle = (Bottle *)[_managedObjectContext objectWithID:bottleID];
        [Invoice toggleBottle:bottle inInvoice:_invoice inContext:_managedObjectContext];
    }
    [self reload];
}


// Iterate over the bottles in the order to find that orderForBottle
-(BOOL)bottleIsSelectedWithID:(NSManagedObjectID *)bottleID {
    Bottle * bottle = (Bottle *)[_managedObjectContext objectWithID:bottleID];
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

// user edited price and quantity -- veryify that price doesn't exceed last order
-(void)didFinishEditingPrice:(NSNumber *)price andQuantity:(NSNumber *)quantity forObject:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    invoiceForBottle.quantity = quantity;
    invoiceForBottle.unitPrice = price;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * nowComps = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[nowComps year] - 1];
    [components setMonth:[nowComps month]];
    [components setDay:1];
    NSDate * date = [calendar dateFromComponents:components];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InvoiceForBottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(bottle.userHasBottle = %@) AND (bottle.barcode = %@) AND (invoice.dateReceived > %@) AND (unitPrice <= %@) AND (invoice != %@)", [NSNumber numberWithBool:YES], invoiceForBottle.bottle.barcode, date, invoiceForBottle.unitPrice, invoiceForBottle.invoice];
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor * sorter1 = [NSSortDescriptor sortDescriptorWithKey:@"unitPrice" ascending:YES];
    NSArray * sorters = @[sorter1];
    [fetchRequest setSortDescriptors:sorters];
    
    NSError * err;
    NSArray * fetchedBottleInvoices = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (fetchedBottleInvoices.count == 0) {
        return;
    }
    
    InvoiceForBottle * otherInvoice = [fetchedBottleInvoices lastObject];
    if ([otherInvoice.unitPrice isEqualToNumber:invoiceForBottle.unitPrice]) {
        return; // the most recent order was at this price, so no discrepency
    }
    NSString * badPriceString = [_numberFormatter stringFromNumber:price];
    NSString * lowerPriceString = [_numberFormatter stringFromNumber:otherInvoice.unitPrice];
    NSString * message  = [NSString stringWithFormat:@"You just marked %@ as %@ but within the last week you purchased it for %@", invoiceForBottle.bottle.name, badPriceString, lowerPriceString];
    UIAlertView * badPriceAlertView = [[UIAlertView alloc] initWithTitle:@"Price Discrepancy" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Approve Price Change", @"Ok, I'll Contact The Vendor", nil];
    [badPriceAlertView show];
    
    
}

-(NSNumber *)priceOfObj:(id)obj {
    InvoiceForBottle * invoiceForBottle = (InvoiceForBottle *)obj;
    return invoiceForBottle.unitPrice;
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
