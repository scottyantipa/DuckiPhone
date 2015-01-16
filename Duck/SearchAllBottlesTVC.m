//
//  SearchAllBottlesTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/15/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

//
// NOTE: A lot of the UISegmentControl is copy/pasted from AllMyBottlesTVC
//

#import "SearchAllBottlesTVC.h"

@implementation SearchAllBottlesTVC
@synthesize alcoholTypeToFilter = _alcoholTypeToFilter;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedBottle = _selectedBottle;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void)viewDidLoad {
    _managedObjectContext = [self getContext]; // use the shared MOC instead of creating a new one
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:0]; // get default filter, which is 'Liquor'
    [self setHeader];
    [self fetch];
}

-(NSManagedObjectContext *)getContext {
    return [[MOCManager sharedInstance] managedObjectContext];
}

//
// Methods for fetching data from server and fetching data from core date
// They will do very similar things.  Once we fetch from server we will populate core data and then
// render.
//


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSString * entityName = [_alcoholTypeToFilter stringByAppendingString:@"Bottle"];  // kind of hacky, but creates WineBottle, LiquorBottle, or BeerBottle
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = nil;
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ranking" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // No section because we are showing all of a type sorted by ranking
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

// Get data from server
-(void)fetch {
    PFQuery * query = [PFQuery queryWithClassName:@"Bottle"];
    [query whereKey:@"alcoholType" equalTo:_alcoholTypeToFilter];
    [query orderByDescending:@"ranking"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded, so make sure bottle is stored in persistent store
            for (PFObject * serverObj in objects) {
                [Bottle bottleFromServerInfo:serverObj inContext:_managedObjectContext];
            }
            [[MOCManager sharedInstance] saveContext:_managedObjectContext];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.tableView reloadData];
    }];
}

// Do fetch here so that if we pop a modal up showing a bottle, we reload when modal is closed
// Instead of this though we should have a modal method for when modal closes --> reload
-(void)viewWillAppear:(BOOL)animated {
    [self resetCoreDataElements];
    [self.tableView reloadData];
}


-(void)setHeader {
    _filterControl = nil; // just to be safe
    UISegmentedControl * control = [[UISegmentedControl alloc] initWithItems:[Utils typesOfAlcohol]];
    [control addTarget:self action:@selector(controlChanged) forControlEvents:UIControlEventValueChanged];
    [control setSelectedSegmentIndex:0];
    CGFloat fullWidth = self.tableView.frame.size.width;
    CGFloat fullHeight = 70;
    CGFloat controlWidth = fullWidth - 40;
    CGFloat controlHeight = control.frame.size.height;
    CGFloat controlXOffset = (fullWidth / 2) - (controlWidth / 2);
    CGFloat controlYOffset = (fullHeight / 2) - 10; // remove ten so the middle of the control is more or less in middle vertically
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight)];
    [control setFrame:CGRectMake(controlXOffset, controlYOffset, controlWidth, controlHeight)];
    [headerView addSubview:control];
    _filterControl = control;
    self.tableView.tableHeaderView = headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Bottle * bottle = (Bottle *)[_fetchedResultsController objectAtIndexPath:indexPath];
    BottleInfoTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"Search All Cell ID"];
    [BottleInfoTableViewCell formatCell:cell forBottle:bottle];
    if ([bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone; // have to do this otherwise the reused cells will always have a checkmark
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BottleInfoTableViewCell totalCellHeight];
}


-(void)controlChanged {
    [self resetCoreDataElements];
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:_filterControl.selectedSegmentIndex];
    [self fetch];
}

-(void)resetCoreDataElements {
    _fetchedResultsController = nil;
    _managedObjectContext = nil; // reset the managedObjectContext
    _managedObjectContext = [self getContext];
}

// When table cell is selected, sync the bottle and then perform segue when sync comes back
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedBottle = (Bottle *)[_fetchedResultsController objectAtIndexPath:indexPath];
    if ([_selectedBottle.alcoholType isEqualToString:@"Wine"]) {
        [self performSegueWithIdentifier:@"Show Wine Bottle From Search Segue ID" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"Show Bottle From Search Segue ID" sender:nil];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BottleTVC * tvc = (BottleTVC *)[[segue destinationViewController] topViewController];
    tvc.bottleID = _selectedBottle.objectID;
}

- (IBAction)didPressSearch:(id)sender {

}


- (IBAction)didPressDone:(id)sender {
    [self.delegate didPressDoneOnModal];
}

@end
