//
//  ToggleBottlesTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 11/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "ToggleBottlesTableViewController.h"
#import "AlcoholSubType+Create.h"

@interface ToggleBottlesTableViewController ()

@end

@implementation ToggleBottlesTableViewController
// why do I have to synthesize these here, as well as in the parent class?
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchFetchedResultsController = _searchFetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize searchBar = _searchBar;
@synthesize subType = _subType;
@synthesize varietal = _varietal;
@synthesize purposeDescription = _purposeDescription;

#pragma FRC creation

// There are two FRC's, one for search and one for the main table.  This is used just for the search table.
- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString
{
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray * sortDescriptors = @[sortDescriptor];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:nil];
    
    /*
     Set up the fetched results controller.
     */
    NSMutableArray *predicateArray = [NSMutableArray array];
    if (searchString.length)
    {
        // your search predicate(s) are added to this array
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString]];
        
        // If we only want to see bottles in a certain subtype or varietal.  Note this code is duplicated in the standard tvc.
        if (_subType != nil) {
            [predicateArray addObject:[NSPredicate predicateWithFormat:@"subType.name = %@", _subType.name]];
        } else if (_varietal) {
            [predicateArray addObject:[NSPredicate predicateWithFormat:@"varietal.name = %@", _varietal.name]];
        }

        // finally add the filter predicate for this view
        if(filterPredicate)
        {
            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray], nil]];
        }
        else
        {
            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
        }
    }
    NSString * entityName;
    if (_subType != nil) {
        entityName = @"Bottle";
    } else if (_varietal != nil) {
        entityName = @"WineBottle";
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setPredicate:filterPredicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:[self managedObjectContext]
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return aFetchedResultsController;
}


// This is the main FRC
// Controller should show all bottles organized by subType, sorted by userOrdering/userHasBottle/name
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSString * entityName;
    // If we only want to see bottles in a certain subtype.  Note this code is duplicated in th search table frc.
    NSPredicate * predicate;
    if (_subType != nil) {
        predicate = [NSPredicate predicateWithFormat:@"subType.name = %@", _subType.name];
        entityName = @"Bottle";
    } else if (_varietal != nil) {
        predicate = [NSPredicate predicateWithFormat:@"varietal.name = %@", _varietal.name];
        entityName = @"WineBottle";
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setPredicate:predicate];

    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor1;
    if (_subType != nil) {
        sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"subType.name" ascending:NO];
    } else if (_varietal != nil) {
        sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"varietal.name" ascending:NO];
    }
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray * sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSString * keyPath;
    if (_subType != nil) {
        keyPath = @"subType.name";
    } else if (_varietal != nil) {
        keyPath = @"varietal.name";
    }
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:keyPath cacheName:nil];
    _fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    return _managedObjectContext;
}


// get the search FRC
- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (_searchFetchedResultsController != nil)
    {
        return _searchFetchedResultsController;
    }
    _searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    return _searchFetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float searchBarHeight = 44.0;
    float totalHeight;
    float labelHeight;
    UILabel * messageLabel;
    if (_purposeDescription != nil) {
        labelHeight = 30;
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, searchBarHeight, self.tableView.frame.size.width - 40, labelHeight)];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [messageLabel setFont:[UIFont systemFontOfSize:12]];
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.text = _purposeDescription;
    } else {
        labelHeight = 0;
        messageLabel = nil;
    }
    totalHeight = searchBarHeight + labelHeight;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, totalHeight)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, searchBarHeight)];
    _searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [headerView addSubview:messageLabel];
    [headerView addSubview:_searchBar];
    
    self.tableView.tableHeaderView = headerView;
    
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.mySearchDisplayController.delegate = self;
    self.mySearchDisplayController.searchResultsDataSource = self;
    self.mySearchDisplayController.searchResultsDelegate = self;
    
    self.searchDisplayController.searchBar.delegate = self;
    
    self.fetchedResultsController = nil;
}

#pragma Search Bar Delegates
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"search bar text is now: %@", searchText);
//}
//


// we're going to show the main table view so let's reload it
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[self tableView] reloadData];
}
//

#pragma Utils for managing the FRCs
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BOOL isChecked = NO;
    if (_subType != nil) {
        Bottle * bottle = [fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = bottle.name;
        isChecked = [self.delegate bottleIsSelectedWithID:bottle.objectID];
    } else if (_varietal != nil) {
        WineBottle * wineBottle = [fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", wineBottle.vineyard.name, wineBottle.varietal.name];
        isChecked = [self.delegate bottleIsSelectedWithID:wineBottle.objectID];
    }

    if (isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    UITableViewCell * cell;
    if (theTableView == self.searchDisplayController.searchResultsTableView) {
        cell = [[self tableView] dequeueReusableCellWithIdentifier:@"All Bottles to Toggle Cell ID"];
    } else {
        cell = [[self tableView] dequeueReusableCellWithIdentifier:@"All Bottles to Toggle Cell ID" forIndexPath:theIndexPath];
    }
    [self fetchedResultsController:[self fetchedResultsControllerForTableView:theTableView] configureCell:cell atIndexPath:theIndexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    
    return count;
}

// Toggle if the user has/doesnt have the bottle
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController * frc = [self fetchedResultsControllerForTableView:tableView];
    Bottle * bottle = [frc objectAtIndexPath:indexPath];
    [self.delegate didSelectBottleWithId:bottle.objectID];
    _fetchedResultsController = nil;
    _searchFetchedResultsController = nil;
    _managedObjectContext = nil;
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *sections = fetchController.sections;
    if(sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewBottleFromToggleBottles"]) {
        BottleDetailTableViewController * bottleTVC = (BottleDetailTableViewController*)[[segue destinationViewController] topViewController];
        Bottle * newBottle = [Bottle newBottleForBarcode:@"null" inManagedObjectContext:[self managedObjectContext]];
        // by default put it in their collection.  If they don't save the bottle then it doesn't matter anyways.
        newBottle.userHasBottle = [NSNumber numberWithBool:YES];
        [[MOCManager sharedInstance] saveContext:[self managedObjectContext]];
        bottleTVC.bottleID = newBottle.objectID;
        bottleTVC.managedObjectContext = [self managedObjectContext];
        bottleTVC.delegate = self;
    }
}

#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    // if you care about the scope save off the index to be used by the serchFetchedResultsController
    //self.savedScopeButtonIndex = scope;
}


#pragma mark -
#pragma mark Search Bar
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    // search is done so get rid of the search FRC and reclaim memory
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    [[self tableView] reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

//
// Content changes in tableViews.  First couple methods are for editing the tableView, which aren't used right now
//
#pragma make sure that you use the correct table view when getting updates from the FRC delegate methods
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)theIndexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsController:controller configureCell:[tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//
// For begin/end updates, make sure to begin/end for the proper tableView
//
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView endUpdates];
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView beginUpdates];
}

#pragma Customizing search

// Turn off the vertical letters on RHS of tableView (looks bad and doesn't provide much utility)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

// Change text of cancel button.
// http://stackoverflow.com/questions/2536151/how-to-change-the-default-text-of-cancel-button-which-appears-in-the-uisearchbar/14509280#14509280
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"Done"];
}

// This is a little tricky.  This TVC can be used to toggle bottles for any reason -- put them in/out of an order or invoice, or mark them as in the user's collction.
//  If it's being used to toggle whether they are in the users collection, then when this method is called and the user has created a new bottle, we don't want our delegate
// to toggle the userHasBottle property because we ourselves have set it in this TVC when we passed the new bottle to BottleDetailTVC.  So don't alert delegate when this is the case.
-(void)didFinishEditingBottleWithId:(NSManagedObjectID *)bottleID
{
    _fetchedResultsController = nil;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
    Bottle * bottle = (Bottle *)[[self managedObjectContext] objectWithID:bottleID];
    if (!bottle.userHasBottle) {
        if  ([self.delegate bottleIsSelectedWithID:bottleID]) {
            // the bottle isn't selected so we need to alert delegate
            [self.delegate didSelectBottleWithId:bottleID];
        } else {
            [self.delegate didSelectBottleWithId:nil];
        }

    } else {
        // The user didn't keep the bottle so we do nothing here
        [self.delegate didSelectBottleWithId:nil];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didPressDone:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
