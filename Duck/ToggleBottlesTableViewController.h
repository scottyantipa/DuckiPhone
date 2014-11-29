//
//  ToggleBottlesTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 11/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

// A helper view which displays bottles in Core Data, and allows user to
// select/deselect the bottles for any generic purpose.
// The way search is implemented was inspired by this SO post: http://stackoverflow.com/questions/4471289/how-to-filter-nsfetchedresultscontroller-coredata-with-uisearchdisplaycontroll/4481896#4481896


// TODO: Unify the creation of the two FRC's.  Los of boileterplate duplicated between them

#import "BaseCoreDataTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType+Create.h"
#import "ToggleBottlesDelegate.h"
#import "BottleDetailDelegate.h"
#import "BottleDetailTableViewController.h"
#import "Varietal.h"
#import "Vineyard.h"

@interface ToggleBottlesTableViewController : BaseCoreDataTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, BottleDetailDelegate>
@property (weak) id <ToggleBottlesDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (strong, nonatomic) AlcoholSubType *subType;
@property (strong, nonatomic) Varietal * varietal;
@end
