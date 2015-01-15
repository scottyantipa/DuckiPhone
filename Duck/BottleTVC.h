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
#import "TakeInventoryTableViewCell.h"

@interface BottleTVC : UITableViewController
@property (strong, nonatomic) NSManagedObjectID * bottleID;
@property (strong, nonatomic) Bottle * bottle;
@property (weak) Class bottleClass;
@property (strong, nonatomic) NSMutableOrderedSet * cellsForTable;
@property float editedCount; // user can change count of bottle, only save on 'Done' so keep track here
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSString * tableCellIdentifier;

-(NSUInteger)propertiesSection;
-(NSUInteger)addOrRemoveSection;
-(NSUInteger)inventorySection;

-(NSMutableOrderedSet *)calculateCellsForTable;
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cellType:(NSString *)property;
-(void)setFinalCount;
@end
