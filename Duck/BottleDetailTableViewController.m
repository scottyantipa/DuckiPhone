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

@interface BottleDetailTableViewController ()

@end

@implementation BottleDetailTableViewController
@synthesize bottleID = _bottleID;
@synthesize whiteList = _whiteList;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize editedCount = _editedCount;
@synthesize bottle = _bottle;

-(void)viewDidLoad
{
    self.whiteList = [Bottle whiteList];
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    _bottle = (Bottle *)[_managedObjectContext objectWithID:_bottleID];
    _editedCount = [[Bottle countOfBottle:_bottle forContext:_managedObjectContext] floatValue];
    if (!_bottle.name) {
        self.title = @"New Bottle";
    }
    else {
        self.title = _bottle.name;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self makeRequest:@"POST"];
}

// check that they've added a name and category before alerting delegate we're done editing
- (IBAction)didPressDone:(id)sender {
    bool noCategory = _bottle.subType == nil;
    // note that "No Name" is the default name we provide when creating a new bottle
    bool noName = [_bottle.name isEqualToString:@""] || _bottle.name == nil || [_bottle.name isEqualToString:@"No Name"];
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
    _bottle.userHasBottle = [NSNumber numberWithBool:YES]; //if they ever edit a bottle or create a bottle, add it to their collection.
    [self setFinalCount];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.delegate didFinishEditingBottleWithId:_bottle.objectID];
}
- (IBAction)didPressCancel:(id)sender {
    [self.delegate didFinishEditingBottleWithId:_bottle.objectID];
}

-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:_editedCount] forBottle:_bottle inManagedObjectContext:_managedObjectContext];
}

-(void)makeRequest:(NSString *)method {

    NSString * encodedBottleName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)_bottle.name,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    
    
    NSMutableString * remoteUrl = [NSMutableString stringWithFormat:@"http://ec2-54-82-243-92.compute-1.amazonaws.com:3333/bottle?"];
    NSMutableString * localUrl = [NSMutableString stringWithFormat:@"http://10.0.1.5:3333/bottle?"];
    BOOL isRemote = NO;
    NSString * urlBase = isRemote ? remoteUrl : localUrl;
    NSString * params = [NSString stringWithFormat:@"name=%@&barcode=%@&category=%@", encodedBottleName, _bottle.barcode, _bottle.subType.name];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_whiteList count] + 1; // all the properties, plus a delete button
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"count"]) {
        TakeInventoryTableViewCell * cell = (TakeInventoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Take Inventory CellID" forIndexPath:indexPath];
        [TakeInventoryTableViewCell formatCell:cell forBottle:_bottle showName:NO];
        // normally this cell would render the bottle name, but we already have the bottle name at the top
        cell.nameLabel.text = @"";
        [cell.plusMinusView.plus1Button addTarget:self action:@selector(didSelectPlus1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.plusMinusView.plus5Button addTarget:self action:@selector(didSelectPlus5:) forControlEvents:UIControlEventTouchUpInside];
        [cell.plusMinusView.minus1Button addTarget:self action:@selector(didSelectMinus1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.plusMinusView.minus5Button addTarget:self action:@selector(didSelectMinus5:) forControlEvents:UIControlEventTouchUpInside];
        cell.editCountLabel.text = [NSString stringWithFormat:@"%g", _editedCount];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];;
        if ([property isEqualToString:@"subType"]) {
            if (!_bottle.subType) {
                cell.textLabel.text = @"Enter Category";
            } else {
                cell.textLabel.text = [_bottle.subType name];
            }
        }
        else if ([property isEqualToString:@"barcode"]) {
            NSNumberFormatter * numFormatter = [[NSNumberFormatter alloc] init];
            [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * barcode = [numFormatter numberFromString:_bottle.barcode];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", barcode];
        }
        else if (property == nil) {
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"REMOVE";
        }
        else {
            cell.textLabel.text = [_bottle valueForKey:property];
        }
        
        return cell;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"count"]) {
        return [TakeInventoryTableViewCell totalCellHeight];
    } else {
        return 44.0;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }

    if ([property isEqualToString:@"subType"]) {
        return @"category";
    }
    else if ([property isEqualToString:@"count"]) {
        return @"edit your inventory count";
    }
    else if ([property isEqualToString:@"barcode"]) {
        return @"tap to scan barcode";
    }
    else if (property == nil) {
        return @"remove from your collection";
    }
    else if ([property isEqualToString:@"name"]) {
        return @"name on label";
    } else {
        return @"error";
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
    } else if ([segue.identifier isEqualToString:@"Show Scanner From Bottle Detail"]) {
        SingleBarcodeScanner * scanner = (SingleBarcodeScanner *)[[segue destinationViewController] topViewController];
        scanner.delegate = self;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id property;
    NSInteger section = indexPath.section;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
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
    }
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
    _editedCount = _editedCount + (float)increment > 0 ? _editedCount + (float)increment : 0;
    [self.tableView reloadData];
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
    [[self navigationController] popViewControllerAnimated:YES];
}

-(NSString *)textForNameView {
    return _bottle.name;
}


#pragma Actions and Outlets
- (void)didTouchDelete {
    _bottle.userHasBottle = [NSNumber numberWithBool:NO];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.delegate didFinishEditingBottleWithId:_bottle.objectID];
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
        _bottle.barcode = barcode;
        [self.tableView reloadData];
    }];
    
}


@end
