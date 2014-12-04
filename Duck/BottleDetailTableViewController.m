//
//  BottleDetailTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

// This is subclassed by WineBottleDetailTVC

#import "BottleDetailTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType+Create.h"
#import "AllSubTypesTableViewController.h"
#import "EditTextViewController.h"
#import "InventorySnapshotForBottle+Create.h"

@interface BottleDetailTableViewController ()

@end

@implementation BottleDetailTableViewController
@synthesize bottleID = _bottleID;
@synthesize whiteList = _whiteList;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize editedCount = _editedCount;
@synthesize bottle = _bottle;
@synthesize bottleClass = _bottleClass;
@synthesize subTypeForNewBottleID = _subTypeForNewBottleID;

-(void)viewDidLoad
{
    [self setup];
    [self setTitle];
}

-(void)setTitle {
    Bottle * bottle = (Bottle *)self.bottle;
    if (!bottle.name) {
        self.title = @"New Bottle";
    }
    else {
        self.title = bottle.name;
    }
}

-(void)setup {
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    _whiteList = [Bottle whiteList];
    if (_bottleID != nil) {
        _bottle = [_managedObjectContext objectWithID:_bottleID];
    } else {
        _bottle = [Bottle newBottleForBarcode:@"" inManagedObjectContext:_managedObjectContext];
        Bottle * bottle = (Bottle *)_bottle;
        bottle.userHasBottle = [NSNumber numberWithBool:YES];

        if  (_subTypeForNewBottleID != nil) {
            AlcoholSubType * subType = (AlcoholSubType *)[_managedObjectContext objectWithID:_subTypeForNewBottleID];
            bottle.subType = subType;
            bottle.type = subType.parent;
        }
        _bottleID = bottle.objectID;
    }

    _editedCount = [[Bottle countOfBottle:_bottle forContext:_managedObjectContext] floatValue];
}

// check that they've added a name and category before alerting delegate we're done editing
- (IBAction)didPressDone:(id)sender {
    Bottle * bottle = (Bottle *)_bottle;
    bool noCategory = bottle.subType == nil;
    // note that "No Name" is the default name we provide when creating a new bottle
    bool noName = [bottle.name isEqualToString:@""] || bottle.name == nil || [bottle.name isEqualToString:@"No Name"];
    NSString * alertMessage;
    if (noCategory && noName) {
        alertMessage = @"You must provide a name and a category";
    } else if (noCategory) {
        alertMessage = @"You must provide a category";
    } else if (noName) {
        alertMessage = @"You must provide a name";
    }
    if (alertMessage != nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:alertMessage message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    bottle.userHasBottle = [NSNumber numberWithBool:YES]; //if they ever edit a bottle or create a bottle, add it to their collection.
    [self setFinalCount];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.delegate didFinishEditingBottleWithId:self.bottleID];
}
- (IBAction)didPressCancel:(id)sender {
    [self.delegate didFinishEditingBottleWithId:self.bottleID];
}

-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:self.editedCount] forBottle:self.bottle inManagedObjectContext:self.managedObjectContext];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.whiteList count] + 1; // all the properties, plus a delete button
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }
    return [self configureCellForPath:indexPath tableView:tableView property:property];
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

-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView property:(NSString *)property {
    if ([property isEqualToString:@"count"]) {
        return [self configureCountCellForPath:indexPath tableView:tableView];
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];;
        if ([property isEqualToString:@"subType"]) {
            return [self configureSubTypeCell:cell];
        } else if ([property isEqualToString:@"barcode"]) {
            return [self configureBarcodeCell:cell];
        } else if ([property isEqualToString:@"volume"]) {
            return [self configureVolumeCell:cell];
        }
        else if (property == nil) {
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"REMOVE";
            return cell;
        } else {
            cell.textLabel.text = [self valueForBottleProp:property ofBottle:self.bottle];;
            return cell;
        }
    }
}

-(NSString *)valueForBottleProp:(NSString *)property ofBottle:(id)bottle {
    return [bottle valueForKey:property];
}


-(UITableViewCell *)configureSubTypeCell:(UITableViewCell *)cell {
    AlcoholSubType * subType = [(Bottle *)self.bottle subType];
    if (!subType) {
        cell.textLabel.text = @"Enter Category";
    } else {
        cell.textLabel.text = [subType name];
    }
    return cell;
}

// should not init the numberFormatter here
-(UITableViewCell *)configureBarcodeCell:(UITableViewCell *)cell {
    NSNumberFormatter * numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * barcode = [numFormatter numberFromString:[(Bottle *)self.bottle barcode]];
    if (barcode == nil) {
        cell.textLabel.text = @"Enter Barcode";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", barcode];
    }
    return cell;
}

-(UITableViewCell *)configureVolumeCell:(UITableViewCell *)cell {
    cell.textLabel.text = [(Bottle *)self.bottle volume];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    id property;
    if (section <= [self.whiteList count] - 1) {
        property = [self.whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"count"]) {
        return [TakeInventoryTableViewCell totalCellHeight];
    } else {
        return 44.0;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id property;
    if (section <= [self.whiteList count] - 1) {
        property = [self.whiteList objectAtIndex:section];
    }

    if ([property isEqualToString:@"subType"]) {
        return @"category";
    }
    else if ([property isEqualToString:@"count"]) {
        return @"inventory";
    }
    else if ([property isEqualToString:@"barcode"]) {
        return @"tap to scan barcode";
    }
    else if (property == nil) {
        return @"remove from your collection";
    }
    else if ([property isEqualToString:@"name"]) {
        return @"name";
    } else if ([property isEqualToString:@"volume"]) {
        return @"volume";
    } else {
        return @"";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Edit Bottle Category"]) {
        AllSubTypesTableViewController * subTypesTable = [segue destinationViewController];
        [subTypesTable setManagedObjectContext:self.managedObjectContext];
        subTypesTable.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"Edit Bottle Name"]) {
        EditTextViewController * editTextHelperView = [segue destinationViewController];
        editTextHelperView.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Scanner From Bottle Detail"]) {
        SingleBarcodeScanner * scanner = (SingleBarcodeScanner *)[[segue destinationViewController] topViewController];
        scanner.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Volume Picker Segue ID"]) {
        BaseOptionPickerTVC * tvc = (BaseOptionPickerTVC *)[segue.destinationViewController topViewController];
        [tvc setData:[Utils volumesForBottleClass:[self classForBottleType]]];
        tvc.delegate = self;
        tvc.title = @"Edit Volume";
        tvc.selectedValue = [(Bottle *)_bottle volume];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id property;
    NSInteger section = indexPath.section;
    if (section <= [self.whiteList count] - 1) {
        property = [self.whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"name"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Name" sender:nil];
    }
    else if ([property isEqualToString:@"subType"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Category" sender:nil];
    }
    else if ([property isEqualToString:@"barcode"]) {
        [self performSegueWithIdentifier:@"Show Scanner From Bottle Detail" sender:nil];
    } else if (property == nil) {
        [self didTouchDelete];
    } else if ([property isEqualToString:@"volume"]) {
        [self performSegueWithIdentifier:@"Show Volume Picker Segue ID" sender:nil];
    }
}

// Volue picker delegate method
-(void)didFinishPickingWithValue:(NSString *)value {
    Bottle * bottle = (Bottle *)_bottle;
    [bottle setVolume:value];
    [self.tableView reloadData];
}

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

#pragma Protocal Functions

// protocal for PickCategory
-(void)didFinishSelectingSubType:(AlcoholSubType *)subType
{
    [AlcoholSubType changeBottle:(Bottle *)self.bottle toSubType:subType inContext:_managedObjectContext];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFinishEditingText:(NSString *)name
{
    [(Bottle *)self.bottle setName:name];
    self.title = name;
    [self.tableView reloadData];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(NSString *)textForNameView {
    return [(Bottle *)self.bottle name];
}


#pragma Actions and Outlets
- (void)didTouchDelete {
    [(Bottle *)self.bottle setUserHasBottle:[NSNumber numberWithBool:NO]];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.delegate didFinishEditingBottleWithId:[(Bottle *)self.bottle objectID]];
}

#pragma Alert View delegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self setFinalCount];
}

#pragma Delegate methods for Scanner

-(void)didFindMetaData:(AVMetadataMachineReadableCodeObject *)metaDataObj
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        NSString * barcode = [metaDataObj stringValue];
        if ([barcode isEqualToString:@""]) {
            return;
        }
        [(Bottle *)self.bottle setBarcode:barcode];
        [self.tableView reloadData];
    }];
    
}

#pragma Sending POST
-(NSMutableString *)remoteUrl {
    return [NSMutableString stringWithFormat:@"http://ec2-54-82-243-92.compute-1.amazonaws.com:3333/bottle?"];
}

-(NSMutableString *)localUrl {
    return [NSMutableString stringWithFormat:@"http://10.0.1.5:3333/bottle?"];
}

-(void)makeRequest:(NSString *)method {
    Bottle * bottle = (Bottle *)self.bottle;
    NSString * encodedBottleName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                         NULL,
                                                                                                         (CFStringRef)bottle.name,
                                                                                                         NULL,
                                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                         kCFStringEncodingUTF8 ));
    
    
    NSMutableString * remoteUrl = [self remoteUrl];
    NSMutableString * localUrl = [self localUrl];
    BOOL isRemote = NO;
    NSString * urlBase = isRemote ? remoteUrl : localUrl;
    NSString * params = [NSString stringWithFormat:@"name=%@&barcode=%@&category=%@", encodedBottleName, bottle.barcode, bottle.subType.name];
    NSString * urlString = [urlBase stringByAppendingString:params];
    NSURL * url = [NSURL URLWithString:urlString];
    
    // create the reqeust, set the method, and send it
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


// These connection methods are not in use right now
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //    NSLog(@"finished loading connection %@", connection);
}
-(void)connection:(NSConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //    NSLog(@"got response %@", response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //    NSLog(@"didReceiveData %@", data);
}


@end
