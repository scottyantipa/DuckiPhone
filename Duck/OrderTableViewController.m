//
//  NewOrderTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "OrderTableViewController.h"

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize order = _order;


// Lazy instantiate an order if there isn't one.  If there is an order, add affordance
// to Re-order from the vendor
- (void)viewDidLoad
{
    if (!_order) {
        _order = [Order newOrderForDate:[NSDate date] inManagedObjectContext:_managedObjectContext];
    } else {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
        UIButton * orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [orderButton addTarget:self action:@selector(reOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderButton setTitle:@"Re-order from Vendor" forState:UIControlStateNormal];
        orderButton.frame = CGRectMake(0, 0, screenWidth, 70);
        [headerView addSubview:orderButton];
        self.tableView.tableHeaderView = headerView;
    }
    self.title = @"Order";
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

#pragma Actions

// Delete order, pop controller
- (IBAction)didDeleteOrder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_managedObjectContext deleteObject:_order];
}

-(void)reOrder {
    MFMailComposeViewController * mailTVC = [Order mailComposeForOrder:_order];
    mailTVC.delegate = self;
    [self presentViewController:mailTVC animated:YES completion:nil];
}


#pragma Delegate methods
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"Within mailComposer finish method");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
