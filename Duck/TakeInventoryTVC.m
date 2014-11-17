//
//  TakeInventoryTVC.m
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTVC.h"

@interface TakeInventoryTVC ()

@end

@implementation TakeInventoryTVC

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize editedValues = _editedValues;

- (void)viewDidLoad {
    [super viewDidLoad];
    _editedValues = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(userHasBottle = %@)", [NSNumber numberWithBool:YES]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor * sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"subType.name" ascending:NO];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSArray * sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"subType.name" cacheName:@"Master"];
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
    TakeInventoryTableViewCell *cell = (TakeInventoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Take Inventory CellID" forIndexPath:indexPath];
    Bottle * bottle = [_fetchedResultsController objectAtIndexPath:indexPath];
    [TakeInventoryTableViewCell formatCell:cell forBottle:bottle];

    float countToDisplay;
    id editedVal = [_editedValues objectForKey:[bottle objectID]];
    if (editedVal != nil) {
        countToDisplay = [editedVal floatValue];
    } else {
        countToDisplay = [[Bottle countOfBottle:bottle forContext:_managedObjectContext] floatValue];
    }
    cell.editCountLabel.text = [NSString stringWithFormat:@"%g units", countToDisplay];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(void)didSelectMinus:(UIButton *)sender {  
    Bottle * bottle = [self bottleForSender:sender];
    [self incrementBottle:bottle byInt:-1];
}

-(void)didSelectPlus:(UIButton *)sender {
    Bottle * bottle = [self bottleForSender:sender];
    [self incrementBottle:bottle byInt:1];
}

-(void)incrementBottle:(Bottle *)bottle byInt:(int)increment {
    id editedVal = [_editedValues objectForKey:[bottle objectID]];
    float valueToSet;
    if (editedVal == nil) {
        float currentCount = [[Bottle countOfBottle:bottle forContext:_managedObjectContext] floatValue];
        valueToSet = currentCount + (float)increment;
    } else {
        valueToSet = (float)increment + [(NSNumber *)editedVal floatValue];
    }
    valueToSet = valueToSet <= 0 ? 0 : valueToSet; // can't have negative inventory
    
    [_editedValues setObject:[NSNumber numberWithFloat:valueToSet] forKey:[bottle objectID]];
    [self.tableView reloadData];
}

-(Bottle *)bottleForSender:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[sender superview];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    return (Bottle *)[_fetchedResultsController objectAtIndexPath:indexPath];
}


- (IBAction)didPressDone:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.color = [UIColor blueColor];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate * now = [NSDate date];
        for (NSManagedObjectID * key in _editedValues) {
            Bottle * bottle = (Bottle *)[_managedObjectContext objectWithID:key];
            id editedVal = [_editedValues objectForKey:key];
            if (editedVal == nil) {
                continue; // this shouldnt happen, just a safegaurd
            }
            [InventorySnapshotForBottle newInventoryForBottleSnapshotForDate:now withCount:(NSNumber *)editedVal forBottle:bottle inManagedObjectContext:_managedObjectContext];
            NSError *error;
            if (![_managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // stop and remove the spinner on the background when done
            [spinner removeFromSuperview];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });

}


// TODO: Alert view
- (IBAction)didPressCancel:(id)sender {
    if (_editedValues.count != 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your changes will not be saved.  Do you still want to cancel?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 1;
        [alert show];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"button index %u", buttonIndex);
    if (buttonIndex == 1) { // "OK"
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

@end
