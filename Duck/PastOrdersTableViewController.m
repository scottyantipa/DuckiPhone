//
//  PastOrdersTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "PastOrdersTableViewController.h"
#import "BottlesInOrderTableViewController.h"

@interface PastOrdersTableViewController ()

@end

@implementation PastOrdersTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize numberFormatter = _numberFormatter;
@synthesize dateFormatter = _dateFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Past Orders";
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self setHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// create button as header of table to add more bottles
-(void)setHeader {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int headerHeight = 80;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, screenWidth - 40, headerHeight)];
    
    BFPaperButton *newOrderButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, 20, 280, 43) raised:NO];
    [newOrderButton setTitle:@"New Order" forState:UIControlStateNormal];
    newOrderButton.backgroundColor = [UIColor paperColorGray600];  // This is from the included cocoapod "UIColor+BFPaperColors".
    [newOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [newOrderButton addTarget:self action:@selector(didSelectNewOrder) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:newOrderButton];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)didSelectNewOrder {
    [self performSegueWithIdentifier:@"Show New Order" sender:nil];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Past Orders Reuse ID" forIndexPath:indexPath];
    Order * order = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString * dateString = [_dateFormatter stringFromDate:order.date];
    cell.textLabel.text = [Order description:order withNumForatter:_numberFormatter];
    cell.detailTextLabel.text = dateString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OrderTableViewController * tvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Show New Order"]) {
        tvc.order = [Order newOrderForDate:[NSDate date] inManagedObjectContext:_managedObjectContext];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Order * order = [self.fetchedResultsController objectAtIndexPath:indexPath];
        tvc.order = order;
    }
    [tvc setManagedObjectContext:_managedObjectContext];
}

@end
