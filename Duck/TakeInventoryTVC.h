//
//  TakeInventoryTVC.h
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Bottle+Create.h"
#import "TakeInventoryTableViewCell.h"
#import "InventorySnapshotForBottle+Create.h"

@interface TakeInventoryTVC : BaseCoreDataTableViewController <UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableDictionary * editedValues;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@end
