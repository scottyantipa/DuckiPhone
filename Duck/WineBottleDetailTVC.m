//
//  WineBottleDetailTVC.m
//  Duck
//
//  Created by Scott Antipa on 11/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "WineBottleDetailTVC.h"

@implementation WineBottleDetailTVC
@synthesize bottleID = _bottleID;
@synthesize whiteList = _whiteList;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize editedCount = _editedCount;
@synthesize bottle = _bottle;

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setup {
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    _bottle = [_managedObjectContext objectWithID:_bottleID];
    _whiteList = [WineBottle whiteList];
    _editedCount = [[Bottle countOfWineBottle:_bottle forContext:_managedObjectContext] floatValue];
}

-(void)setTitle {
    if (![(WineBottle *)_bottle vineyard]) {
        self.title = @"New Wine";
    }
    else {
        self.title = [(WineBottle *)_bottle name];
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    id property;
    if (section <= [_whiteList count] - 1) {
        property = [_whiteList objectAtIndex:section];
    }
    return [self configureCellForPath:indexPath tableView:tableView property:property];
}

// if property is not in Bottle whiteList, then do unique thing, otherwise delegate to super
-(UITableViewCell *)configureCellForPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView property:(NSString *)property {
    if  ([property isEqualToString:@"varietal"] || [property isEqualToString:@"vineyard"]) {
        WineBottle * bottle = (WineBottle *)_bottle;
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];;
        if ([property isEqualToString:@"varietal"]) {
            cell.textLabel.text = [[bottle varietal] name];
            return cell;
        } else if ([property isEqualToString:@"vineyard"]) {
            cell.textLabel.text= [[bottle vineyard] name];
            return cell;
        }
    }

    return [super configureCellForPath:indexPath tableView:tableView property:property];
}

- (IBAction)didPressCancel:(id)sender {
    [self.delegate didFinishEditingBottleWithId:_bottleID];
}

- (IBAction)didPressDone:(id)sender {
    WineBottle * wineBottle = (WineBottle *)_bottle;
    bool noVarietal = wineBottle.varietal == nil;
    // note that "No Name" is the default name we provide when creating a new bottle
    bool noVineyard = wineBottle.vineyard == nil;
    NSString * alertMessage;
    if (noVarietal && noVineyard) {
        alertMessage = @"You must provide a Vineyard and a Varietal";
    } else if (noVineyard) {
        alertMessage = @"You must provide a Vineyard";
    } else if (noVarietal) {
        alertMessage = @"You must provide a Varietal";
    }
    if (alertMessage != nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:alertMessage message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    wineBottle.userHasBottle = [NSNumber numberWithBool:YES]; //if they ever edit a bottle or create a bottle, add it to their collection.
    [self setFinalCount];
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.delegate didFinishEditingBottleWithId:wineBottle.objectID];
}

-(void)setFinalCount {
    [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:[NSDate date] withCount:[NSNumber numberWithFloat:_editedCount] wineBottle:(WineBottle *)_bottle inManagedObjectContext:_managedObjectContext];
}

-(void)didFinishEditingText:(NSString *)name
{
    [(WineBottle *)_bottle setName:name];
    self.title = name;
    [self.tableView reloadData];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(NSString *)textForNameView {
    return [(WineBottle *)_bottle name];
}

//
// Post Requests
//

-(void)makeRequest:(NSString *)method {
    WineBottle * bottle = (WineBottle *)_bottle;
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
    NSString * params = [NSString stringWithFormat:@"name=%@&barcode=%@&varietal=%@", encodedBottleName, bottle.barcode, bottle.varietal.name];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id property;
    if (section <= [self.whiteList count] - 1) {
        property = [self.whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"vineyard"]) {
        return @"vineyard";
    } else if ([property isEqualToString:@"varietal"]) {
        return @"varietal";
    } else {
        return [super tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section];
    }
}

@end
