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
@synthesize varietalForNewBottleID = _varietalForNewBottleID;

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setTitle];
}

-(void)setup {
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    if (_bottleID != nil) {
        _bottle = [_managedObjectContext objectWithID:_bottleID];
    } else {
        _bottle = [Bottle newWineBottleForName:@"" varietal:nil inManagedObjectContext:[self managedObjectContext]];
        WineBottle * bottle = (WineBottle *)_bottle;
        bottle.userHasBottle = [NSNumber numberWithBool:YES];
        if (_varietalForNewBottleID != nil) {
            Varietal * varietal = (Varietal *)[_managedObjectContext objectWithID:_varietalForNewBottleID];
            bottle.varietal = varietal;
            bottle.subType = varietal.subType;
        }
        _bottleID = bottle.objectID;
    }
    _whiteList = [WineBottle whiteList];
    _editedCount = [[Bottle countOfWineBottle:_bottle forContext:_managedObjectContext] floatValue];
}

-(void)setTitle {
    if (![(WineBottle *)_bottle producer]) {
        self.title = @"New Wine";
    }
    else {
        self.title = [(WineBottle *)_bottle name];
    }
}

-(Class)classForBottleType {
    return [WineBottle class];
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
    if  ([property isEqualToString:@"varietal"] || [property isEqualToString:@"producer"]) {
        WineBottle * bottle = (WineBottle *)_bottle;
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle Property CellID" forIndexPath:indexPath];;
        if ([property isEqualToString:@"varietal"]) {
            cell.textLabel.text = [[bottle varietal] name];
            return cell;
        } else if ([property isEqualToString:@"producer"]) {
            cell.textLabel.text= [[bottle producer] name];
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
    bool noProducer = wineBottle.producer == nil;
    NSString * alertMessage;
    if (noVarietal && noProducer) {
        alertMessage = @"You must provide a Winery and a Varietal";
    } else if (noProducer) {
        alertMessage = @"You must provide a Winery";
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
    if ([property isEqualToString:@"producer"]) {
        return @"winery";
    } else if ([property isEqualToString:@"varietal"]) {
        return @"varietal";
    } else {
        return [super tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id property;
    NSInteger section = indexPath.section;
    if (section <= [self.whiteList count] - 1) {
        property = [self.whiteList objectAtIndex:section];
    }
    if ([property isEqualToString:@"varietal"]) {
        [self performSegueWithIdentifier:@"Show Varietal Picker Segue ID" sender:nil];
    }
    else if ([property isEqualToString:@"producer"]) {
        [self performSegueWithIdentifier:@"Show Producer Picker Segue ID" sender:nil];
    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WineBottle * bottle = (WineBottle *)_bottle;
    if ([segue.identifier isEqualToString:@"Show Varietal Picker Segue ID"]) {
        PickVarietalTVC * tvc = (PickVarietalTVC *)[segue.destinationViewController topViewController];
        tvc.selectedVarietal = bottle.varietal;
        tvc.managedObjectContext = _managedObjectContext;
        tvc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Producer Picker Segue ID"]) {
        PickProducerTVC * tvc = (PickProducerTVC *)[segue.destinationViewController topViewController];
        tvc.managedObjectContext = _managedObjectContext;
        tvc.selectedProducer = bottle.producer;
        tvc.delegate = self;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)didFinishPickingWithValue:(NSString *)value {
    WineBottle * bottle = (WineBottle *)_bottle;
    [bottle setVolume:value];
    [self.tableView reloadData];
}

-(void)didFinishPickingVarietal:(Varietal *)varietal {
    WineBottle * bottle = (WineBottle *)_bottle;
    bottle.varietal = varietal;
    bottle.subType = varietal.subType;
    [self.tableView reloadData];
}

-(void)didFinishPickingProducer:(Producer *)producer {
    WineBottle * bottle = (WineBottle *)_bottle;
    bottle.producer = producer;
    [self.tableView reloadData];
}

@end
