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
@synthesize bottleServerID = _bottleServerID;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bottle = _bottle;

- (void)viewDidLoad {
    [super viewDidLoad];
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    [Bottle bottleFromServerID:_bottleServerID inManagedObjectContext:_managedObjectContext forTarget:self withSelector:@selector(syncFinished:)];
    // TODO : This needs to provide a callback for when query is done so I can reload the table
}

// bottle has been synced with server
-(void)syncFinished:(id)bottle {
    _bottle = (Bottle *)bottle;
    [[MOCManager sharedInstance] saveContext:_managedObjectContext];
    [self.tableView reloadData];
 }
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self userHasBottle]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2; // name and volume
    } else {
        return 1; // if user has or doesnt have bottle, each section only has one row
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"BottleTVC Cell ID"];
    
    // First section (header) isnt dependenton userHasBottle
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _bottle.name;
        } else {
            cell.textLabel.text = _bottle.volume ? _bottle.volume : @"No Volume";
        }
    } else if (indexPath.section == 1) { // "Add" or "Remove"
        cell.textLabel.textColor = [UIColor whiteColor];
        if ([self userHasBottle]) {
            cell.textLabel.text = @"REMOVE FROM COLLECTION";
            cell.backgroundColor = [UIColor redColor];
        } else {
            cell.textLabel.text = @"ADD TO COLLECTION";
            cell.backgroundColor = [UIColor greenColor];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) { // they clicked the ADD/REMOVE button
        [Bottle toggleUserHasBottle:_bottle inContext:_managedObjectContext];
        [[MOCManager sharedInstance] saveContext:_managedObjectContext];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

- (IBAction)didPressDone:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)userHasBottle {
    return [_bottle.userHasBottle boolValue];
}


@end
