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

-(void)setSubType:(AlcoholSubType *)subType
{
    _subType = subType;
    self.title = subType.name;
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

-(void)showHint {
    _plusButtonToolTip = [[CMPopTipViewStyleOverride alloc] initWithMessage:[NSString stringWithFormat:@"Tap here to add some %@ to your collection.", _subType.name]];
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

-(NSManagedObjectContext *)context {
    return self.subType.managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subType.name = %@) AND (userHasBottle = %@)", self.subType.name, [NSNumber numberWithBool:YES]];

    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // in case no user ordering for the bottle
    NSArray *sortDescriptors = @[sortDescriptor, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // get the results and print them
//    NSError *err;
//    NSArray *fetchedObjects = [self.subType.managedObjectContext executeFetchRequest:fetchRequest error:&err];
//    for (Bottle *bottle in fetchedObjects) {
//        NSLog(@"fetched result: %@ with order %@", bottle.name, bottle.userOrdering);
//    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self context] sectionNameKeyPath:nil cacheName:nil];
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
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Toggle Subtype Bottles Segue ID"]) { // wants to add bottles
        ToggleBottlesTableViewController * tvc = [segue destinationViewController];
        tvc.delegate = self;
        tvc.managedObjectContext = [self context];
        [[segue destinationViewController] setSubType:_subType];
    } else { // selected a bottle, so show the bottle
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Bottle *bottle = [self.fetchedResultsController objectAtIndexPath:indexPath];
        BottleDetailTableViewController * bottleTVC = (BottleDetailTableViewController*)[[segue destinationViewController] topViewController];
        bottleTVC.bottle = bottle;
        bottleTVC.managedObjectContext = [self context];
        bottleTVC.delegate = self;
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath == destinationIndexPath) {
        return;
    }
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:sourceIndexPath];
    NSNumber * newOrderNum = [NSNumber numberWithInt:destinationIndexPath.row];
    [AlcoholSubType changeOrderOfBottle:bottle toNumber:newOrderNum inContext:[self context]];
    [[self tableView] reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) { // bottle was deleted
        bottle.userHasBottle = [NSNumber numberWithBool:NO];
        int order = [bottle.userOrdering intValue];
        NSArray * fetchedBottles = [_fetchedResultsController fetchedObjects];
        // update the ordering of the bottles
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
        NSError *error;
        if (![[self context] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
}

#pragma Delegate parent methods for toggle bottles

-(void)didSelectBottle:(Bottle *)bottle {
    [Bottle toggleUserHasBottle:bottle inContext:[self context]];
    [[self tableView] reloadData];
}


-(BOOL)bottleIsSelected:(Bottle *)bottle {
    return [bottle.userHasBottle boolValue];
}

#pragma Delegate methods for StandardModal

-(void)didFinishEditingBottle:(Bottle *)bottle {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
