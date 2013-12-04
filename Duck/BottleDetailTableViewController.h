//
//  BottleDetailTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Bottle.h"
#import "SubTypeSelectorDelegate.h"
#import "EditNameViewDelegate.h"
#import "EditCountDelegate.h"

@interface BottleDetailTableViewController : BaseCoreDataTableViewController <SubTypeSelectorDelegate, EditTextViewDelegate, EditCountDelegate>
@property (strong, nonatomic) Bottle * bottle;
@property (strong, nonatomic) NSOrderedSet * whiteList;
@end
