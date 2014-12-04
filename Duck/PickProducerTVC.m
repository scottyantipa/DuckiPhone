//
//  PickProducerTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "PickProducerTVC.h"

@interface PickProducerTVC ()

@end

@implementation PickProducerTVC
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedProducer = _selectedProducer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Pick Producer"];
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Producer" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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

// NOTE that we check the objectID equivalency so managedObject must be same as the delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Pick Producer Cell ID" forIndexPath:indexPath];
    Producer * producer = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = producer.name;
    if ([producer.objectID isEqual:_selectedProducer.objectID]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Producer * producer = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate didFinishPickingProducer:producer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didPressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// let user enter name of a new Producer
- (IBAction)didPressNew:(id)sender {
    if ([UIAlertView class]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter New Producer Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 0;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if  ((alertView.tag == 0) && buttonIndex == 1) {
        NSString * producerName = [[alertView textFieldAtIndex:0] text];
        Producer * producer = [Bottle newProducerForName:producerName inContext:_managedObjectContext];
        [self.tableView reloadData];
        [self.delegate didFinishPickingProducer:producer];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
