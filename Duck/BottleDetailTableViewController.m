//
//  BottleDetailTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BottleDetailTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType+Create.h"
#import "AllSubTypesTableViewController.h"
#import "EditTextViewController.h"
#import "InventorySnapshotForBottle+Create.h"
#import "EditManagedObjCountViewController.h"

@interface BottleDetailTableViewController ()

@end

@implementation BottleDetailTableViewController

@synthesize bottle = _bottle;
@synthesize whiteList = _whiteList;
@synthesize managedObjectContext = _managedObjectContext;

-(void)viewDidLoad
{
    if (!_bottle.name) {
        self.title = @"New Bottle";
    }
    else {
        self.title = _bottle.name;
    }
    self.whiteList = [Bottle whiteList];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)context {
    _managedObjectContext = context;
}

-(void)setBottleInfo:(Bottle *)bottleInfo {
    _bottle = bottleInfo;
}

-(NSNumber *)countOfBottle {
    // Get the most recent InventorySnapshotForBottle
    // and set that count to _count
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InventorySnapshotForBottle" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"whichBottle.name = %@", _bottle.name];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    // We only want the most recent one
    [fetchRequest setFetchBatchSize:1];
    
    NSError * err = nil;
    NSArray * fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    InventorySnapshotForBottle * snapshot = [fetchedObjects lastObject];
    
    return snapshot.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_whiteList count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    id property = [_whiteList objectAtIndex:row];
    NSString *nameForProperty = [self nameForProperty:property];
    cell.detailTextLabel.text = nameForProperty;
    if ([property isEqualToString:@"subType"]) {
        if (!_bottle.subType) {
            cell.textLabel.text = @"Enter Category";
        } else {
            cell.textLabel.text = [_bottle.subType name];
        }
    }
    else if ([property isEqualToString:@"count"]) {
        if (!self.countOfBottle) {
            cell.textLabel.text = @"Enter Count";
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.countOfBottle];
        }
    }
    else if ([property isEqualToString:@"barcode"]) {
        NSNumberFormatter * numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * barcode = [numFormatter numberFromString:_bottle.barcode];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", barcode];
    }
    else {
        cell.textLabel.text = [_bottle valueForKey:property];
    }
}

-(NSString *)nameForProperty:(NSString *)property {
    if ([property isEqualToString:@"subType"]) {
        NSString *name = @"Category";
        return name;
    }
    else {
        return property;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Edit Bottle Category"]) {
        AllSubTypesTableViewController * subTypesTable = [segue destinationViewController];
        [subTypesTable setManagedObjectContext:_managedObjectContext];
        subTypesTable.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"Edit Bottle Name"]) {
        EditTextViewController * editTextHelperView = [segue destinationViewController];
        editTextHelperView.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"Edit Bottle Count"]) {
        EditManagedObjCountViewController * editCountView = [segue destinationViewController];
        editCountView.delegate = self;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    id property = [_whiteList objectAtIndex:row];
    if ([property isEqualToString:@"name"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Name" sender:nil];
    }
    else if ([property isEqualToString:@"subType"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Category" sender:nil];
    }
    else if ([property isEqualToString:@"count"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Count" sender:nil];
    }
}

#pragma Protocal Functions

-(void)didFinishSelectingSubType:(AlcoholSubType *)subType
{
    [AlcoholSubType changeBottle:_bottle toSubType:subType inContext:_managedObjectContext];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFinishEditingText:(NSString *)name
{
    _bottle.name = name;
    self.title = name;
    [self.tableView reloadData];
}

-(NSString *)textForNameView {
    return _bottle.name;
}

-(void)didFinishEditingCount:(NSNumber *)count forObject:(id)obj {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:count forBottle:_bottle inManagedObjectContext:_managedObjectContext];
    [self.tableView reloadData];
}

-(float)countOfManagedObject:(id)obj {
    NSNumber * num = self.countOfBottle;
    float countAsFloat = [num floatValue];
    return countAsFloat;
    
}

#pragma Actions and Outlets
- (IBAction)didTouchDelete:(id)sender {
    self.bottle.userHasBottle = [NSNumber numberWithBool:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
