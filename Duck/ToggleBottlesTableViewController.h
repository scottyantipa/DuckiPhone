//
//  ToggleBottlesTableViewController.h
//  Duck
//
//  Created by Scott Antipa on 11/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

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
