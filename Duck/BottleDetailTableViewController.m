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
    [self.delegate didFinishEditingBottle:_bottle];
}

-(void)makeRequest:(NSString *)method {
    NSUUID * uuid = [[UIDevice currentDevice] identifierForVendor];
    NSString * stringId = [uuid UUIDString];

    // make sure name param url encoded for whitespaces etc. (got this from: http://stackoverflow.com/questions/8088473/url-encode-an-nsstring)
    NSString * encodedID = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)stringId,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]-",
                                                                                         kCFStringEncodingUTF8 ));


    NSString * encodedBottleName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)_bottle.name,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    
    
    NSMutableString * remoteUrl = [NSMutableString stringWithFormat:@"http://ec2-54-82-243-92.compute-1.amazonaws.com:3333/bottle?"];
    NSMutableString * localUrl = [NSMutableString stringWithFormat:@"http://10.0.1.5:3333/bottle?"];
    BOOL isRemote = YES;
    NSString * urlBase = isRemote ? remoteUrl : localUrl;
    NSString * params = [NSString stringWithFormat:@"name=%@&barcode=%@&category=%@&device=%@", encodedBottleName, _bottle.barcode, _bottle.subType.name, encodedID];
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



-(void)setManagedObjectContext:(NSManagedObjectContext *)context {
    _managedObjectContext = context;
}

-(void)setBottleInfo:(Bottle *)bottleInfo {
    _bottle = bottleInfo;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }

    if ([property isEqualToString:@"subType"]) {
        if (!_bottle.subType) {
            cell.textLabel.text = @"Enter Category";
        } else {
            cell.textLabel.text = [_bottle.subType name];
        }
    }
    else if ([property isEqualToString:@"count"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Bottle countOfBottle:_bottle forContext:_managedObjectContext]];
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
        return @"your inventory count";
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
    }
    else if ([[segue identifier] isEqualToString:@"Edit Bottle Count"]) {
        EditManagedObjCountViewController * editCountView = [segue destinationViewController];
        editCountView.delegate = self;
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
    else if ([property isEqualToString:@"count"]) {
        [self performSegueWithIdentifier:@"Edit Bottle Count" sender:nil];
    }
    else if ([property isEqualToString:@"barcode"]) {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        
        // Disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        // present and release the controller
        [self presentViewController: reader
                           animated: YES
                         completion:nil
         ];
    } else if (property == nil) {
        [self didTouchDelete];
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
    [[self navigationController] popViewControllerAnimated:YES];
}

-(NSString *)textForNameView {
    return _bottle.name;
}

-(void)didFinishEditingCount:(NSNumber *)count forObject:(id)obj {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:count forBottle:_bottle inManagedObjectContext:_managedObjectContext];
    [self.tableView reloadData];
}

-(float)countOfManagedObject:(id)obj {
    NSNumber * num = [Bottle countOfBottle:obj forContext:_managedObjectContext];
    float countAsFloat = [num floatValue];
    return countAsFloat;
    
}

#pragma Actions and Outlets
- (void)didTouchDelete {
    self.bottle.userHasBottle = [NSNumber numberWithBool:NO];
    [self.delegate didFinishEditingBottle:nil];
}

#pragma Alert View delegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

#pragma Delegate methods for ZBar

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    // just grab the first symbol
    for(symbol in results)
        break;
    
    NSString * resultText = symbol.data;
    _bottle.barcode = resultText;
    [[self tableView] reloadData];
    [reader dismissViewControllerAnimated:YES completion:nil];
}


@end
