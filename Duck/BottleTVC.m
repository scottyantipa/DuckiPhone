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

// Should these be constants?  Cant figure out how subclasses can inherit constants...
// Override if you'd like
-(NSUInteger)propertiesSection {
    return 0;
}
-(NSUInteger)addOrRemoveSection {
    return 1;
}
-(NSUInteger)inventorySection {
    return 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [[MOCManager sharedInstance] managedObjectContext];
    self.bottle = (Bottle *)[self.managedObjectContext objectWithID:self.bottleID];
    NSString * name = [self.bottle fullName];
    self.title = name ? name : @"Bottle";
    self.editedCount = [[Bottle countOfBottle:self.bottle forContext:self.managedObjectContext] floatValue];
    self.cellsForTable = [self calculateCellsForTable];
}

// should be a constant, but I wasn't sure how to share
// logic with subclasses if this isn't a method
-(NSString *)tableCellIdentifier {
    return @"BottleTVC Cell ID";
}

// must be called whenever userHasBottle changes
-(NSMutableOrderedSet *)calculateCellsForTable {
    return [[NSMutableOrderedSet alloc] initWithObjects:@"name", @"volume", @"producer", nil];
}
 
#pragma mark - Table view data source

// we need a cell for each property and cell for the add/remove button
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        return 3; // properties, "remove", and "inventory"
    } else {
        return 2; // properties, "add"
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == [self propertiesSection]) {
        return [self.cellsForTable count];
    } else { // either the add/remove button or the inventory cell
        return 1;
    }
}

// If we are in the properties section then configure a cell for that property
// otherwise, it will either be a button for add/remove or inventory
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellType;
    if (indexPath.section == [self propertiesSection]) {
        cellType = [self.cellsForTable objectAtIndex:indexPath.row];
    } else if (indexPath.section == [self addOrRemoveSection]) {
        cellType = [self.bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]] ? @"remove" : @"add";
    } else if (indexPath.section == [self inventorySection]) {
        cellType = @"count";
    }
    return [self configureCellForPath:indexPath tableView:tableView cellType:cellType];
}

// calls the various cell configuration methods like configureVolumeCell
// This gets overridden in subclass and called with super
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cellType:(NSString *)cellType {
    bool showDetail = YES;
    if ([cellType isEqualToString:@"count"]) { // its a different kind of cell
        showDetail = NO;
        return [self configureCountCellForPath:indexPath tableView:tableView];
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self tableCellIdentifier] forIndexPath:indexPath];
        if ([cellType isEqualToString:@"volume"]) {
            NSString * registeredVolume = [(Bottle *)self.bottle volume];
            cell.textLabel.text = registeredVolume ? registeredVolume : @"No Volume";
        } else if ([cellType isEqualToString:@"producer"]) {
            cell.textLabel.text = self.bottle.producerName ? self.bottle.producerName : @"No producer";
        } else if ([cellType isEqualToString:@"add"]) {
            cell.textLabel.text = @"Add to collection";
            cell.backgroundColor = [UIColor greenColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            showDetail = NO;
        } else if ([cellType isEqualToString:@"remove"]) {
            cell.textLabel.text = @"Remove from collection";
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            showDetail = NO;
        } else if ([cellType isEqualToString:@"name"]) {
            cell.textLabel.text = [self.bottle fullName];
        } else { // generic case which will be called for subclasses with different property types (like Wine has Vintage)
            cell.textLabel.text = [self valueForBottleProp:cellType ofBottle:self.bottle];;
        }
        cell.detailTextLabel.text = showDetail ? cellType : @"";
        return cell;
    }
}

#pragma Cell Config methods
-(TakeInventoryTableViewCell *)configureCountCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // normally this cell would render the bottle name, but we already have the bottle name at the top
    TakeInventoryTableViewCell * cell = (TakeInventoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Take Inventory CellID" forIndexPath:indexPath];
    [TakeInventoryTableViewCell formatCell:cell forBottle:self.bottle showName:NO];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self inventorySection]) {
        return [TakeInventoryTableViewCell totalCellHeight];
    } else {
        return 44.0; // standard celll height
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == [self inventorySection]) {
        return @"inventory";
    } else {
        return @"";
    }
}

#pragma Actions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if  (indexPath.section == [self addOrRemoveSection]) {
        [Bottle toggleUserHasBottle:self.bottle inContext:self.managedObjectContext];
        [[MOCManager sharedInstance] saveContext:self.managedObjectContext];
        self.cellsForTable = [self calculateCellsForTable]; // we're going to add an inventory cell so we need to recalculate
        [self.tableView reloadData];
    }
}

- (IBAction)didPressDone:(id)sender {
    [self setFinalCount];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma Utils

// override this and return the type of bottle e.g. WineBottle
-(Class)classForBottleType {
    if (_bottleClass != nil)
    {
        return _bottleClass;
    } else {
        return [Bottle class];
    }
}

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
