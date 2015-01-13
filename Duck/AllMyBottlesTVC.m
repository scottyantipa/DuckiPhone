//
//  AllMyBottlesTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/14/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "AllMyBottlesTVC.h"

@implementation AllMyBottlesTVC

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize alcoholTypeToFilter = _alcoholTypeToFilter;
@synthesize filterControl = _filterControl;

-(void)viewDidLoad {
    _managedObjectContext = [[MOCManager sharedInstance] managedObjectContext];
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:0]; // first one is liquor;
    [self setHeader];
}

-(void)setHeader {
    _filterControl = nil; // just to be safe
    UISegmentedControl * control = [[UISegmentedControl alloc] initWithItems:[Utils typesOfAlcohol]];
    [control addTarget:self action:@selector(controlChanged) forControlEvents:UIControlEventValueChanged];
    [control setSelectedSegmentIndex:0];
    CGFloat fullWidth = self.tableView.frame.size.width;
    CGFloat fullHeight = 60;
    CGFloat controlWidth = fullWidth - 40;
    CGFloat controlHeight = control.frame.size.height;
    CGFloat controlXOffset = (fullWidth / 2) - (controlWidth / 2);
    CGFloat controlYOffset = (fullHeight / 2);
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight)];
    [control setFrame:CGRectMake(controlXOffset, controlYOffset, controlWidth, controlHeight)];
    [headerView addSubview:control];
    _filterControl = control;
    self.tableView.tableHeaderView = headerView;
}

-(void)controlChanged {
    _fetchedResultsController = nil;
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:_filterControl.selectedSegmentIndex];
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSString * entityName = [_alcoholTypeToFilter stringByAppendingString:@"Bottle"];  // kind of hacky, but creates WineBottle, LiquorBottle, or BeerBottle
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userHasBottle = %@", [NSNumber numberWithBool:YES]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"alcoholSubType" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"alcoholSubType" cacheName:@"Master"];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"All My Bottles Cell ID"];
    NSManagedObject * obj = [_fetchedResultsController objectAtIndexPath:indexPath];
    if ([_alcoholTypeToFilter isEqualToString:@"Wine"]) {
        WineBottle * wineBottle = (WineBottle *)obj;
        cell.textLabel.text = wineBottle.varietalName;
    } else if ([_alcoholTypeToFilter isEqualToString:@"Liquor"]) {
        LiquorBottle * liquorBottle = (LiquorBottle *)obj;
        cell.textLabel.text = liquorBottle.name;
    } else if ([_alcoholTypeToFilter isEqualToString:@"Beer"]) {
        BeerBottle * beerBottle = (BeerBottle *)obj;
        cell.textLabel.text = beerBottle.name;
    }
    return cell;
}

// removes the vertical scroll navigation with letters in it
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show All Bottles Segue ID"]) {
        SearchAllBottlesTVC * tvc = (SearchAllBottlesTVC *)[segue.destinationViewController topViewController];
        tvc.delegate = self;
    }
}

// delegate method for search tvc
-(void)didPressDoneOnModal {
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
