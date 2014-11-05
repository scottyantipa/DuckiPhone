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
#import "EditTextViewDelegate.h"
#import "EditCountDelegate.h"
#import "StandardModalDelegate.h"

@interface BottleDetailTableViewController : BaseCoreDataTableViewController <SubTypeSelectorDelegate, EditTextViewDelegate, EditCountDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) Bottle * bottle;
@property (strong, nonatomic) NSOrderedSet * whiteList;
@property (weak) id <StandardModalDelegate> delegate;
@end
