//
//  WineTVC.m
//  Duck
//
//  Created by Scott Antipa on 1/8/15.
//  Copyright (c) 2015 Scott Antipa. All rights reserved.
//

#import "WineTVC.h"

@interface WineTVC ()

@end

@implementation WineTVC
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bottleID = _bottleID;
@synthesize bottle = _bottle;
@synthesize cellsForTable = _cellsForTable;
@synthesize editedCount = _editedCount;


-(NSString *)tableCellIdentifier {
    return @"Wine BottleTVC Cell ID";
}

-(NSArray *)wineProps {
    return @[@"varietal", @"vintage"];
}

// use the base properties provided by super class (like "name", "volume")
-(NSMutableOrderedSet *)calculateCellsForTable {
    NSMutableOrderedSet * toReturn = [NSMutableOrderedSet orderedSetWithOrderedSet:[super calculateCellsForTable]];
    [toReturn addObjectsFromArray:[self wineProps]];
    return toReturn;
}

// if property is not in Bottle whiteList, then do unique thing, otherwise delegate to super
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cellType:(NSString *)cellType {
    WineBottle * bottle = (WineBottle *)_bottle;
    NSInteger isInMyProperties = [[self wineProps] indexOfObject:cellType];
    bool showDetail = YES;
    if (!(NSNotFound == isInMyProperties)) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self tableCellIdentifier] forIndexPath:indexPath];
        if ([cellType isEqualToString:@"varietal"]) {
            cell.textLabel.text = bottle.varietalName;
        } else if ([cellType isEqualToString:@"vintage"]) {
            cell.textLabel.text = [bottle.vintage stringValue];
        }
        cell.detailTextLabel.text = showDetail ? cellType : @"";
        return cell;
    } else {
        UITableViewCell * superCell = [super configureCellForPath:indexPath tableView:tableView cellType:cellType];
        return superCell;
    }
}

// need to override this because there is a special Wine method for InventorySnapShot we need to call
-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:_editedCount] wineBottle:(WineBottle *)_bottle inManagedObjectContext:_managedObjectContext];
}


// annoying that this can't be a super method
- (IBAction)didPressDone:(id)sender {
    [self setFinalCount];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
