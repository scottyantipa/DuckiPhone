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
#import <UIKit/UIKit.h>
#import "BottleDetailDelegate.h"
#import "SingleBarcodeScannerDelegate.h"
#import "SingleBarcodeScanner.h"
#import "PlusMinusButtonsView.h"
#import "TakeInventoryTableViewCell.h"
#import "MOCManager.h"
#import "Utils.h"
#import "BasePickerDelegate.h"
#import "BaseOptionPickerTVC.h"

@interface BottleDetailTableViewController : BaseCoreDataTableViewController <SubTypeSelectorDelegate, EditTextViewDelegate, UIAlertViewDelegate, SingleBarcodeScannerDelegate, BasePickerDelegate>
@property (strong, nonatomic) NSManagedObjectID * bottleID;
@property (strong, nonatomic) id bottle;
@property (weak) Class bottleClass;
@property (strong, nonatomic) NSOrderedSet * whiteList;
@property (weak) id <BottleDetailDelegate> delegate;
@property float editedCount;

// methods for subclasses to call
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView property:(NSString *)property;
-(NSMutableString *)localUrl;
-(NSMutableString *)remoteUrl;
-(void)setFinalCount;
@end
