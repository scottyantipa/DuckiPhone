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


-(NSOrderedSet *)calculateCellsForTable {
    if ([self.bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        return [[NSOrderedSet alloc] initWithObjects:@"name", @"volume", @"varietal", @"vintage", @"count", @"remove", nil];
    } else {
        return [[NSOrderedSet alloc] initWithObjects:@"name", @"volume", @"varietal", @"vintage", @"add", nil];
    }
}

// if property is not in Bottle whiteList, then do unique thing, otherwise delegate to super
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cellType:(NSString *)cellType identifier:(NSString *)identifier {
    if  ([cellType isEqualToString:@"varietal"] || [cellType isEqualToString:@"producer"]) {
        WineBottle * bottle = (WineBottle *)_bottle;
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];;
        if ([cellType isEqualToString:@"varietal"]) {
            cell.textLabel.text = bottle.varietalName;
            return cell;
        } else if ([cellType isEqualToString:@"producer"]) {
            cell.textLabel.text= [[bottle producer] name];
            return cell;
        }
    }
    if (cellType) {
        return [super configureCellForPath:indexPath tableView:tableView cellType:cellType];
    } else {
        return nil;
    }

}

// need to override this because there is a special Wine method for InventorySnapShot we need to call
-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:_editedCount] wineBottle:(WineBottle *)_bottle inManagedObjectContext:_managedObjectContext];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * cellType = [self.cellsForTable objectAtIndex:section];
    if ([cellType isEqualToString:@"producer"]) {
        return @"winery";
    } else if ([cellType isEqualToString:@"varietal"]) {
        return @"varietal";
    } else {
        return [super tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section];
    }
}

// annoying that this can't be a super method
- (IBAction)didPressDone:(id)sender {
    [self setFinalCount];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
