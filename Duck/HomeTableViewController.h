//
//  HomeTableViewController.h
//  Duck03
//
//  Created by Scott Antipa on 8/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface HomeTableViewController : UITableViewController < ZBarReaderDelegate >
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end