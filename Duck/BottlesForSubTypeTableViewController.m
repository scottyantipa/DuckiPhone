//
//  BottlesForSubTypeTableViewController.m
//  Duck
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "BottlesForSubTypeTableViewController.h"
#import "Bottle+Create.h"
#import "AlcoholSubType.h"
#import "BottleDetailTableViewController.h"

@interface BottlesForSubTypeTableViewController ()

@end

@implementation BottlesForSubTypeTableViewController
@synthesize subType = _subType;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize plusButtonToolTip = _plusButtonToolTip;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize varietal = _varietal;
@synthesize selectedBottle = _selectedBottle;

-(void)setSubType:(AlcoholSubType *)subType
{
    _subType = subType;
    self.title = subType.name;
}

-(void)setVarietal:(Varietal *)varietal {
    _varietal = varietal;
    self.title = varietal.name;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self drawBarButtons];
}

-(void)viewWillAppear:(BOOL)animated {
    if (_plusButtonToolTip != nil) {
        [_plusButtonToolTip dismissAnimated:YES];
        _plusButtonToolTip = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (_fetchedResultsController.fetchedObjects.count == 0) {
        [self showHint];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    if (_plusButtonToolTip != nil) {
        [_plusButtonToolTip dismissAnimated:YES];
    }
}


// i'm using self.title and ASSUMING that the setter code doesn't change for setSubtype/setVarietal which sets the self.title
-(void)showHint {
    _plusButtonToolTip = [[CMPopTipViewStyleOverride alloc] initWithMessage:[NSString stringWithFormat:@"Tap here to add some %@ to your collection.", self.title]];
    _plusButtonToolTip.delegate = self;
    [CMPopTipViewStyleOverride setStylesForPopup:_plusButtonToolTip];
    UIBarButtonItem * addButton = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
    [_plusButtonToolTip presentPointingAtBarButtonItem:addButton animated:YES];
}

#pragma Delegate methods for tool tip
-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self performSegueWithIdentifier:@"Toggle Subtype Bottles Segue ID" sender:nil];
}

-(void)drawBarButtons {
    UIBarButtonItem * editOrDoneButton;
    if ([self.tableView isEditing]) {
        editOrDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTouchDone)];
    } else {
        editOrDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTouchEdit)];
    }
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchAdd)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editOrDoneButton, addButton, nil];
}

-(void)didTouchEdit {
    [self.tableView setEditing:YES animated:YES];
    [self drawBarButtons];
}

-(void)didTouchDone {
    [self.tableView setEditing:NO animated:YES];
    [self drawBarButtons];
}

-(void)didTouchAdd {
    [self performSegueWithIdentifier:@"Toggle Subtype Bottles Segue ID" sender:nil];
}

-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[MOCManager sharedInstance] newMOC];
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest * fetchRequest;
    if (_subType != nil) {
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subType.name = %@) AND (userHasBottle = %@)", _subType.name, [NSNumber numberWithBool:YES]];
    }
    if (_varietal != nil) {
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"WineBottle"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(varietal.name = %@) AND (userHasBottle = %@)", _varietal.name, [NSNumber numberWithBool:YES]];
    }

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // in case no user ordering for the bottle
    NSArray *sortDescriptors = @[sortDescriptor, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bottle SubTypes CellID" forIndexPath:indexPath];
    Bottle *bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = bottle.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedBottle = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (_subType != nil) {
        [self performSegueWithIdentifier:@"Show Bottle From Bottles" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"Show WineBottle From Bottles" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Toggle Subtype Bottles Segue ID"]) { // wants to add bottles
        ToggleBottlesTableViewController * tvc = (ToggleBottlesTableViewController *)[[segue destinationViewController] topViewController];
        tvc.delegate = self;
        [tvc setPurposeDescription:@"Check bottles to add to your collection"];
        if (_subType != nil) {
            [tvc setSubType:_subType];
        } else if (_varietal != nil) {
            [tvc setVarietal:_varietal];
        }

    } else if ([segue.identifier isEqualToString:@"Show WineBottle From Bottles"]) {
        WineBottle * wineBottle = (WineBottle *)_selectedBottle;
        WineBottleDetailTVC * wineBottleTVC = (WineBottleDetailTVC *)[[segue destinationViewController] topViewController];
        wineBottleTVC.bottleID = wineBottle.objectID;
        wineBottleTVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Bottle From Bottles"]) {
        Bottle *bottle = (Bottle *)_selectedBottle;
        BottleDetailTableViewController * bottleTVC = (BottleDetailTableViewController*)[[segue destinationViewController] topViewController];
        bottleTVC.bottleID = bottle.objectID;
        bottleTVC.delegate = self;
        AlcoholType * type = bottle.subType.parent;
        if ([type.name isEqualToString:@"Liquor"]) {
            bottleTVC.bottleClass = [LiquorBottle class];
        } else if ([type.name isEqualToString:@"Beer"]) {
            bottleTVC.bottleClass = [BeerBottle class];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath == destinationIndexPath) {
        return;
    }
    NSNumber * newOrderNum = [NSNumber numberWithInt:destinationIndexPath.row];
    if  (_subType != nil) {
        Bottle * bottle = [_fetchedResultsController objectAtIndexPath:sourceIndexPath];
        [AlcoholSubType changeOrderOfBottle:bottle toNumber:newOrderNum inContext:[self managedObjectContext]];
    } else if (_varietal != nil) {
        WineBottle * bottle = [_fetchedResultsController objectAtIndexPath:sourceIndexPath];
        [AlcoholSubType changeOrderOfWineBottle:bottle toNumber:newOrderNum inContext:[self managedObjectContext]];
    }
    [[self tableView] reloadData];
}

// this will work regardless of of type of bottle (liquor, wine, beer)
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) { // bottle was deleted
        bottle.userHasBottle = [NSNumber numberWithBool:NO];
        int order = [bottle.userOrdering intValue];
        NSArray * fetchedBottles = [_fetchedResultsController fetchedObjects];
        // update the ordering of the bottles THIS SHOULD BE ABSTRACTED into AlcoholSubType
        for (Bottle * otherBottle in fetchedBottles) {
            if (otherBottle.name == bottle.name) {
                continue;
            }
            int oldOrderForOtherBottle = [otherBottle.userOrdering intValue];
            NSNumber * newOrderForOtherBottle;
            if (order < oldOrderForOtherBottle) { // removed bottle was before this bottle
                newOrderForOtherBottle = [NSNumber numberWithInt:(oldOrderForOtherBottle - 1)];
                otherBottle.userOrdering = newOrderForOtherBottle;
            } else {
                continue; // removed bottle was after this bottle, so no change to the order
            }
        }
        [[MOCManager sharedInstance] saveContext:[self managedObjectContext]];
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
}

#pragma Delegate parent methods for toggle bottles

-(void)didSelectBottleWithId:(NSManagedObjectID *)bottleID {
    _fetchedResultsController = nil; // in case subsequent views alter data, we will want to create a new FRC
    if (bottleID == nil) {
        [self.tableView reloadData];
        return;
    }
    Bottle * bottle = (Bottle *)[[self managedObjectContext] objectWithID:bottleID];
    [Bottle toggleUserHasBottle:bottle inContext:[self managedObjectContext]];
    [[MOCManager sharedInstance] saveContext:[self managedObjectContext]];
    [[self tableView] reloadData];
}

-(BOOL)bottleIsSelectedWithID:(NSManagedObjectID *)bottleID {
    Bottle * bottle = (Bottle *)[[self managedObjectContext] objectWithID:bottleID];
    return [bottle.userHasBottle boolValue];
}

#pragma Delegate methods for StandardModal

-(void)didFinishEditingBottleWithId:(NSManagedObjectID *)bottleID {
    [[MOCManager sharedInstance] saveContext:[self managedObjectContext]];
    _fetchedResultsController = nil;
    _managedObjectContext = nil;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
