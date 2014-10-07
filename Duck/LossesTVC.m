//
//  LossesTVC.m
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "LossesTVC.h"

@interface LossesTVC ()

@end

@implementation LossesTVC
@synthesize startDate = _startDate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize numberFormatter = _numberFormatter;
@synthesize userBottles = _userBottles;
@synthesize lossesForEachBottle = _lossesForEachBottle;
@synthesize totalLosses = _totalLosses;
@synthesize headerTextView = _headerTextView;
- (void)viewDidLoad {
    // get a number formatter for money
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    _lossesForEachBottle = [[NSMutableArray alloc] init];
    
    // create our start date
    [super viewDidLoad];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2012];
    [components setMonth:1];
    [components setDay:1];
    _startDate = [calendar dateFromComponents:components];
    
    [self setUserBottles];
    [self runModel];
    [self setHeader];
    [self reload];
}

-(void)reload {
    [self.tableView reloadData];
    [self setHeaderText];
}

// create button as header of table to "Add More Bottles"
-(void)setHeader {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int headerHeight = 75;
    
    _headerTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, screenWidth - 10, headerHeight)];
    [_headerTextView setTextAlignment:NSTextAlignmentCenter];
    _headerTextView.lineBreakMode = NSLineBreakByWordWrapping;
    _headerTextView.numberOfLines = 0;
    self.tableView.tableHeaderView = _headerTextView;
}

-(void)setHeaderText {
    if (_totalLosses == 0 || !_totalLosses) {
        _headerTextView.text = @"We have gone over all of your historical inoivces and there are no losses due to price variation";
    }
    _headerTextView.text = [NSString stringWithFormat:@"Changes in vendor prices have cost you %@ across all skus", [_numberFormatter stringFromNumber:[NSNumber numberWithFloat:_totalLosses]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_lossesForEachBottle count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * lossInfo = [_lossesForEachBottle objectAtIndex:indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Losses By Bottle Cell"];
    Bottle * bottle = [lossInfo objectForKey:@"bottle"];
    NSNumber * aggLoss = [lossInfo objectForKey:@"aggregateLoss"];
    cell.textLabel.text = bottle.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"losses of %@", [_numberFormatter stringFromNumber:aggLoss]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show losses by bottle"]) {
        NSIndexPath * i = [self.tableView indexPathForCell:sender];
        NSDictionary * dict = [_lossesForEachBottle objectAtIndex:i.row];
        [segue.destinationViewController setLossInfo:dict];
        [segue.destinationViewController setNumberFormatter:_numberFormatter];
    }
}

// calculate all losses since start date
-(void)runModel {
    _totalLosses = 0;
    [_lossesForEachBottle removeAllObjects]; // just to cleanup in case this is called multiple times
    for (Bottle * userBottle in _userBottles) {
        NSMutableDictionary * dict = [self createDictForBottle:userBottle];
        if (!dict) {
            continue;
        }
        [_lossesForEachBottle addObject:dict];
        NSNumber * loss = [dict objectForKey:@"aggregateLoss"];
        _totalLosses += [loss floatValue];
    }
}

// Create a dict that describes the losses/gains from changes in price since start date
-(NSMutableDictionary *)createDictForBottle:(Bottle *)bottle {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InvoiceForBottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(bottle.userHasBottle = %@) AND (bottle.barcode = %@) AND (invoice.dateReceived >= %@)", [NSNumber numberWithBool:YES], bottle.barcode, _startDate];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"invoice.dateReceived" ascending:NO];
    NSArray * sorters = @[sorter];
    [fetchRequest setSortDescriptors:sorters];
    
    // get results and print
    NSError * err;
    NSArray * fetchedBottleInvoices = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];

    
    InvoiceForBottle * oldest = [fetchedBottleInvoices lastObject];
    NSLog(@"oldest: %@", oldest.invoice.dateReceived);
    NSNumber * priceOfOldest = oldest.unitPrice;
    
    NSMutableDictionary * lossesForBottleDict = [[NSMutableDictionary alloc] init];
    NSMutableArray * invoicesWithBadPrice = [[NSMutableArray alloc] init];
    float aggregateLoss = 0;
    for (InvoiceForBottle * bottleInvoice in fetchedBottleInvoices) {
        if (![bottleInvoice.unitPrice isEqual:priceOfOldest]) {
            float loss = [bottleInvoice.quantity floatValue] * ([priceOfOldest floatValue] - [bottleInvoice.unitPrice floatValue]);
            loss = abs(loss);
            aggregateLoss += loss;
            [invoicesWithBadPrice addObject:bottleInvoice];
        }
    }
    
    if (aggregateLoss == 0) {
        return nil;
    }
    
    [invoicesWithBadPrice addObject:oldest]; // because we want to display it (but it will be a loss of 0 so won't affect the value)
    
    [lossesForBottleDict setObject:bottle forKey:@"bottle"];
    [lossesForBottleDict setObject:invoicesWithBadPrice forKey:@"bottleInvoices"];
    [lossesForBottleDict setObject:[NSNumber numberWithFloat:aggregateLoss] forKey:@"aggregateLoss"];
    [lossesForBottleDict setObject:priceOfOldest forKey:@"priceOfOldest"];
    
    return lossesForBottleDict;
}

-(void)setUserBottles {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userHasBottle = %@", [NSNumber numberWithBool:YES]];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // in case no user ordering for the bottle
    NSArray *sortDescriptors = @[sortDescriptor, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // get the results and print them
    //    NSError *err;
    //    NSArray *fetchedObjects = [self.subType.managedObjectContext executeFetchRequest:fetchRequest error:&err];
    //    for (Bottle *bottle in fetchedObjects) {
    //        NSLog(@"fetched result: %@ with order %@", bottle.name, bottle.userOrdering);
    //    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    

    NSError *err;
    _userBottles = [self.managedObjectContext executeFetchRequest:fetchRequest error:&err];
}

@end
