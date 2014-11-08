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
    [self setHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// create button as header of table to add more bottles
-(void)setHeader {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int headerHeight = 80;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, screenWidth - 40, headerHeight)];
    
    BFPaperButton *newOrderButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, 20, 280, 43) raised:NO];
    [newOrderButton setTitle:@"Log Invoice" forState:UIControlStateNormal];
    newOrderButton.backgroundColor = [UIColor paperColorGray600];  // This is from the included cocoapod "UIColor+BFPaperColors".
    [newOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [newOrderButton addTarget:self action:@selector(didSelectNewInvoice) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:newOrderButton];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)didSelectNewInvoice {
    [self performSegueWithIdentifier:@"Show New Invoice" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Invoice * invoice;
    if ([segue.identifier isEqualToString:@"Show Invoice From All Invoices"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        invoice = [_fetchedResultsController objectAtIndexPath:indexPath];
    } else if ([segue.identifier isEqualToString:@"Show New Invoice"]) {
        invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:_managedObjectContext];
        invoice.dateReceived = [NSDate date];
        invoice.vendor = [Vendor newVendorInContext:_managedObjectContext];
    }
    [segue.destinationViewController setInvoice:invoice];
    [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
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
    cell.textLabel.text = [NSString stringWithFormat:@"To %@", [Vendor fullNameOfVendor:invoice.vendor]];
    cell.detailTextLabel.text = [Invoice contentsDescriptionForInvoice:invoice];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
