//
//  LossesTVC.m
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "LossesTVC.h"

@interface LossesTVC ()

@end

@implementation LossesTVC
@synthesize startDate = _startDate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize userBottles = _userBottles;

- (void)viewDidLoad {
    // create our start date
    [super viewDidLoad];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2012];
    [components setMonth:1];
    [components setDay:1];
    _startDate = [calendar dateFromComponents:components];
    
    [self setUserBottles];
    [self runModel];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

// calculate all losses since start date
-(void)runModel {
    for (Bottle * userBottle in _userBottles) {
        [self createDictForBottle:userBottle];
    }
}

// Create a dict that describes the losses/gains from changes in price since start date
-(void)createDictForBottle:(Bottle *)bottle {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InvoiceForBottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(bottle.userHasBottle = %@) AND (bottle.barcode = %@) AND (invoice.dateReceived >= %@)", [NSNumber numberWithBool:YES], bottle.barcode, _startDate];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"invoice.dateReceived" ascending:NO];
    NSArray * sorters = @[sorter];
    [fetchRequest setSortDescriptors:sorters];
    
    // get results and print
    NSError * err;
    NSArray * fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    for (InvoiceForBottle * i in fetchedObjects) {
        NSLog(@"invoideForBottle bottle: %@ and date: %@", i.bottle.name, i.invoice.dateReceived);
    }
}

-(void)setUserBottles {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userHasBottle = %@", [NSNumber numberWithBool:YES]];
    
    
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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    

    NSError *err;
    _userBottles = [self.managedObjectContext executeFetchRequest:fetchRequest error:&err];
}

@end
