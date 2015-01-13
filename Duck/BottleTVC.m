//
//  BottleTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/22/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BottleTVC.h"

@interface BottleTVC ()

@end

@implementation BottleTVC
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bottleID = _bottleID;
@synthesize bottle = _bottle;
@synthesize cellsForTable = _cellsForTable;
@synthesize editedCount = _editedCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [[MOCManager sharedInstance] managedObjectContext];
    self.bottle = (Bottle *)[self.managedObjectContext objectWithID:self.bottleID];
    self.editedCount = [[Bottle countOfBottle:self.bottle forContext:self.managedObjectContext] floatValue];
    self.cellsForTable = [self calculateCellsForTable];
}

// should be a constant, but I wasn't sure how to share
// logic with subclasses if this isn't a method
-(NSString *)tableCellIdentifier {
    return @"BottleTVC Cell ID";
}

// must be called whenever userHasBottle changes
-(NSOrderedSet *)calculateCellsForTable {
    if ([_bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        return [[NSOrderedSet alloc] initWithObjects:@"name", @"volume", @"count", @"remove", nil];
    } else {
        return [[NSOrderedSet alloc] initWithObjects:@"name", @"volume", @"add", nil];
    }
}
 
#pragma mark - Table view data source

// we need a cell for each property and cell for the add/remove button
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellsForTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSString * cellType = [self.cellsForTable objectAtIndex:section];
    return [self configureCellForPath:indexPath tableView:tableView cellType:cellType];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellType = [_cellsForTable objectAtIndex:indexPath.section];
    if ([cellType isEqualToString:@"add"] || [cellType isEqualToString:@"remove"]) {
        [Bottle toggleUserHasBottle:_bottle inContext:_managedObjectContext];
        [[MOCManager sharedInstance] saveContext:_managedObjectContext];
        self.cellsForTable = [self calculateCellsForTable];
        [self.tableView reloadData];
    }
}

- (IBAction)didPressDone:(id)sender {
    [self setFinalCount];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma Cell Config methods
-(TakeInventoryTableViewCell *)configureCountCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // normally this cell would render the bottle name, but we already have the bottle name at the top
    TakeInventoryTableViewCell * cell = [self getCountCellForIndexPath:indexPath tableView:tableView];
    cell.nameLabel.text = @"";
    [cell.plusMinusView.plus1Button addTarget:self action:@selector(didSelectPlus1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusMinusView.plus5Button addTarget:self action:@selector(didSelectPlus5:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusMinusView.minus1Button addTarget:self action:@selector(didSelectMinus1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusMinusView.minus5Button addTarget:self action:@selector(didSelectMinus5:) forControlEvents:UIControlEventTouchUpInside];
    cell.editCountLabel.text = [NSString stringWithFormat:@"%g", self.editedCount];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(TakeInventoryTableViewCell *)getCountCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    TakeInventoryTableViewCell * cell = (TakeInventoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Take Inventory CellID" forIndexPath:indexPath];
    [TakeInventoryTableViewCell formatCell:cell forBottle:self.bottle showName:NO];
    return cell;
}

-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cellType:(NSString *)cellType {
    if ([cellType isEqualToString:@"count"]) {
        return [self configureCountCellForPath:indexPath tableView:tableView];
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self tableCellIdentifier] forIndexPath:indexPath];;
        if ([cellType isEqualToString:@"volume"]) {
            [self configureVolumeCell:cell];
        }
        else if ([cellType isEqualToString:@"add"]) {
            cell.textLabel.text = @"Add to collection";
            cell.backgroundColor = [UIColor greenColor];
            cell.textLabel.textColor = [UIColor whiteColor];
        } else if ([cellType isEqualToString:@"remove"]) {
            cell.textLabel.text = @"Remove from collection";
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor whiteColor];
        } else { // generic case which will be called for subclasses with different property types (like Wine has Vintage)
            cell.textLabel.text = [self valueForBottleProp:cellType ofBottle:self.bottle];;
        }
        return cell;
    }
}

// we just shouldnt show a cell at all if there is no volume
-(UITableViewCell *)configureVolumeCell:(UITableViewCell *)cell {
    NSString * registeredVolume = [(Bottle *)self.bottle volume];
    cell.textLabel.text = registeredVolume ? registeredVolume : @"No Volume";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    id property;
    if (section <= [self.cellsForTable count] - 1) {
        property = [self.cellsForTable objectAtIndex:section];
    }
    if ([property isEqualToString:@"count"]) {
        return [TakeInventoryTableViewCell totalCellHeight];
    } else {
        return 44.0; // standard celll height
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * cellType = [self.cellsForTable objectAtIndex:section];
    if ([cellType isEqualToString:@"count"]) {
        return @"inventory";
    }
    else if ([cellType isEqualToString:@"name"]) {
        return @"name";
    } else if ([cellType isEqualToString:@"volume"]) {
        return @"volume";
    } else {
        return @"";
    }
}

// override this and return the type of bottle e.g. WineBottle
-(Class)classForBottleType {
    if (_bottleClass != nil)
    {
        return _bottleClass;
    } else {
        return [Bottle class];
    }
}


#pragma Utils

-(BOOL)userHasBottle {
    return [self.bottle.userHasBottle boolValue];
}

-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:self.editedCount] forBottle:self.bottle inManagedObjectContext:self.managedObjectContext];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
}


// default way to show value for a particular key of bottle
-(NSString *)valueForBottleProp:(NSString *)property ofBottle:(id)bottle {
    NSString * value;
    if ([property isEqualToString:@"vintage"]) {
        value = [[bottle valueForKey:property] stringValue];
    } else {
        value = [bottle valueForKey:property];
    }
    if (value) {
        return value;
    } else {
        return @""; // probably should throw error
    }
}

#pragma Edit Count Methods

-(void)didSelectMinus1:(UIButton *)sender {
    [self incrementBottleCountByInt:-1];
}

-(void)didSelectMinus5:(UIButton *)sender {
    [self incrementBottleCountByInt:-5];
}

-(void)didSelectPlus1:(UIButton *)sender {
    [self incrementBottleCountByInt:1];
}


-(void)didSelectPlus5:(UIButton *)sender {
    [self incrementBottleCountByInt:5];
}

-(void)incrementBottleCountByInt:(int)increment {
    self.editedCount = self.editedCount + (float)increment > 0 ? self.editedCount + (float)increment : 0;
    [self.tableView reloadData];
}


@end
