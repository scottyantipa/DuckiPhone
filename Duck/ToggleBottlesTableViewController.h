//
//  ToggleBottlesTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 11/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

// A helper view which displays all bottles in Core Data, and allows user to
// select/deselect the bottles.  It could be used for picking which bottles to show in an Order,
// or any other application where a user needs to toggle bottles.
// The way search is implemented was inspired by this SO post: http://stackoverflow.com/questions/4471289/how-to-filter-nsfetchedresultscontroller-coredata-with-uisearchdisplaycontroll/4481896#4481896

#import "BaseCoreDataTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType+Create.h"
#import "ToggleBottlesDelegate.h"

@interface ToggleBottlesTableViewController : BaseCoreDataTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak) id <ToggleBottlesDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@end
