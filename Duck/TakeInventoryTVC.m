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
    [cell.minusButton addTarget:self action:@selector(didSelectMinus:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusButton addTarget:self action:@selector(didSelectPlus:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.plusButton.tag = indexPath.row;
    cell.minusButton.tag = indexPath.row;
    float countToDisplay;
    id editedVal = [_editedValues objectForKey:[bottle objectID]];
    if (editedVal != nil) {
        countToDisplay = [editedVal floatValue];
    } else {
        countToDisplay = [[Bottle countOfBottle:bottle forContext:_managedObjectContext] floatValue];
    }
    cell.editCountLabel.text = [NSString stringWithFormat:@"%g", countToDisplay];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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


- (IBAction)didPressSave:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didPressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
