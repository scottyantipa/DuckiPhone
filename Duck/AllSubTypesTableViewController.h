//
//  AllSubTypesTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 8/31/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "SubTypeSelectorDelegate.h"

@interface AllSubTypesTableViewController : BaseCoreDataTableViewController
@property (weak) id <SubTypeSelectorDelegate> delegate;
@end
