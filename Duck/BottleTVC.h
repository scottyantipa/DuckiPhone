//
//  BottleTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/22/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bottle+Create.h"
#import "MOCManager.h"

@interface BottleTVC : UITableViewController
@property (strong, nonatomic) NSString * bottleServerID;
@property (strong, nonatomic) Bottle * bottle;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * tableIndexingForUserHasBottle;
@property (strong, nonatomic) NSArray * tableIndexingForUserDoesntHaveBottle;
@end
