//
//  SearchAllBottlesTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/15/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

//
// NOTE: A lot of the UISegmentControl is copy/pasted from AllMyBottlesTVC
//

#import "SearchAllBottlesTVC.h"

@implementation SearchAllBottlesTVC
@synthesize alcoholTypeToFilter = _alcoholTypeToFilter;
@synthesize foundObjects = _foundObjects;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedBottleObject = _selectedBottleObject;
@synthesize selectedBottle = _selectedBottle;

-(void)viewDidLoad {
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:0]; // first one is liquor;
    [self setHeader];
    [self fetch];
    _managedObjectContext = [[MOCManager sharedInstance] managedObjectContext]; // use the shared MOC instead of creating a new one
}

-(void)fetch {
    PFQuery * query = [PFQuery queryWithClassName:@"Bottle"];
    [query whereKey:@"alcoholType" equalTo:_alcoholTypeToFilter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            _foundObjects = objects;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.tableView reloadData];
    }];
}

-(void)setHeader {
    _filterControl = nil; // just to be safe
    UISegmentedControl * control = [[UISegmentedControl alloc] initWithItems:[Utils typesOfAlcohol]];
    [control addTarget:self action:@selector(controlChanged) forControlEvents:UIControlEventValueChanged];
    [control setSelectedSegmentIndex:0];
    CGFloat fullWidth = self.tableView.frame.size.width;
    CGFloat fullHeight = 70;
    CGFloat controlWidth = fullWidth - 40;
    CGFloat controlHeight = control.frame.size.height;
    CGFloat controlXOffset = (fullWidth / 2) - (controlWidth / 2);
    CGFloat controlYOffset = (fullHeight / 2) - 10; // remove ten so the middle of the control is more or less in middle vertically
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight)];
    [control setFrame:CGRectMake(controlXOffset, controlYOffset, controlWidth, controlHeight)];
    [headerView addSubview:control];
    _filterControl = control;
    self.tableView.tableHeaderView = headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _foundObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Search All Cell ID"];
    PFObject * foundObj = [_foundObjects objectAtIndex:indexPath.row];
    NSString * name = [foundObj valueForKey:@"name"];
    cell.textLabel.text = name;
    return cell;
}

-(void)controlChanged {
    _alcoholTypeToFilter = [[Utils typesOfAlcohol] objectAtIndex:_filterControl.selectedSegmentIndex];
    [self fetch];
}

// When table cell is selected, sync the bottle and then perform segue when sync comes back
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedBottleObject = (PFObject *)[_foundObjects objectAtIndex:indexPath.row];
    [Bottle bottleFromServerID:_selectedBottleObject.objectId inManagedObjectContext:_managedObjectContext forTarget:self withSelector:@selector(syncFinished:)];
}

// bottle has been synced with server after selecting it
-(void)syncFinished:(id)bottle {
    _selectedBottle = (Bottle *)bottle;
    if ([_selectedBottle.alcoholType isEqualToString:@"Wine"]) {
        [self performSegueWithIdentifier:@"Show Wine Bottle From Search Segue ID" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"Show Bottle From Search Segue ID" sender:nil];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BottleTVC * tvc = (BottleTVC *)[[segue destinationViewController] topViewController];
    tvc.bottleID = _selectedBottle.objectID;
}

- (IBAction)didPressSearch:(id)sender {

}


- (IBAction)didPressDone:(id)sender {
    [self.delegate didPressDoneOnModal];
}

@end
