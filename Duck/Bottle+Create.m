//
//  Bottle+Create.m
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Bottle+Create.h"

@implementation Bottle (Create)
// TODO: Vendor should be included here because people don't order the same sku from multiple vendors
+(NSOrderedSet *)whiteList;
{
    return [NSOrderedSet orderedSetWithObjects:@"name", @"volume", @"subType",@"count", @"barcode", nil];
}

+(Bottle *)bottleFromServerID:(NSString *)serverID inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"serverID = %@", serverID];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // get the results and print them
    NSError *err;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    
    // if none were returned, create one
    if ([fetchedObjects count] == 0) {
        Bottle * newBottle = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Bottle"
                          inManagedObjectContext:context];
        newBottle.serverID = serverID;
        [[MOCManager sharedInstance] saveContext:context];
        return newBottle;
    }
    else {
        Bottle *bottle = [fetchedObjects lastObject];
        return bottle;
    }
}

// Syncs a standard Bottle with a bottle obj fetched from server
// pass forTarget:self withSelector:mySelector to have mySelector called after sync is done
+(void)syncBottleWithServer:(Bottle *)bottle inManagedObjectContext:(NSManagedObjectContext *)context forTarget:(id)target withSelector:(SEL)selector {
    PFQuery * query = [PFQuery queryWithClassName:@"Bottle"];
    [query getObjectInBackgroundWithId:bottle.serverID block:^(PFObject *bottleInfo, NSError *error) {
        bottle.name = (NSString *)bottleInfo[@"name"];
        bottle.alcoholType = (NSString *)bottleInfo[@"alcoholType"];
        bottle.alcoholSubType = (NSString *)bottleInfo[@"alcoholSubType"];
        bottle.volume = (NSString *)bottleInfo[@"volume"];
        NSNumber * barcodeNum = (NSNumber *)bottleInfo[@"barcode"];
        bottle.barcode = [barcodeNum stringValue];
        
        // call the selector like this so we don't get a warning http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        IMP imp  = [target methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(target, selector);
    }];
}


+(void)toggleUserHasBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context {
    bottle.userHasBottle = [NSNumber numberWithBool:![bottle.userHasBottle boolValue]];
    [AlcoholSubType recalculateUserOrderingForSubType:bottle.subType inContext:context];
}

+(Bottle *)bottleForBarcode:(NSString *)barcode inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"barcode = %@", barcode];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // get the results and print them
    NSError *err;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    
    // if none were returned, return NO
    if ([fetchedObjects count] == 0) {
        return NO;
    }
    else {
        Bottle *bottle = [fetchedObjects lastObject];
        return bottle;
    }
}

const NSString * NO_NAME_STRING = @"No Name";

// main way to create a new bottle. YOU NEED A BARCODE -- its our way of uniquely identifying bottles
// and we only let users add a new bottle by scanning the barcode
+(Bottle *)newBottleForBarcode:(NSString *)barcode inManagedObjectContext:(NSManagedObjectContext *)context {
    Bottle *bottle = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Bottle"
                      inManagedObjectContext:context];
    bottle.name = [NO_NAME_STRING copy];
    bottle.barcode = barcode;
    return bottle;
}

// LITTLE hacky, but I know that my Wine Types are Liquor, Wine, Beer and that the NSObjects are just
// those strings with "Bottle" appended
+(Bottle *)newBottleForType:(AlcoholType *)type inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString * entityName = [NSString stringWithFormat:@"%@Bottle", type.name];
    Bottle * bottle = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    bottle.name = [NO_NAME_STRING copy];
    return bottle;
}

+(WineBottle *)newWineBottleForName:(NSString *)name varietal:(Varietal *)varietal inManagedObjectContext:(NSManagedObjectContext *)context {
    WineBottle * bottle = [NSEntityDescription insertNewObjectForEntityForName:@"WineBottle" inManagedObjectContext:context];
    bottle.name = name;
    bottle.varietal = varietal;
    return  bottle;
}

+(OrderForBottle *)mostRecentOrderForBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderForBottle" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"whichBottle.name = %@", bottle.name];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whichOrder.date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // We only want the most recent one
    [fetchRequest setFetchBatchSize:1];
    
    NSError * err = nil;
    NSArray * fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    return [fetchedObjects lastObject];
}

+(InvoiceForBottle *)mostRecentInvoiceForBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InvoiceForBottle" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"bottle.name = %@", bottle.name];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"invoice.dateReceived" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // We only want the most recent one
    [fetchRequest setFetchBatchSize:1];
    
    NSError * err = nil;
    NSArray * fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    return [fetchedObjects lastObject];
}


// THIS IS MESSED UP:  Since I identify the bottle by barcode, all bottles with a null barcode will share the same inventory count
// Get the most recent InventorySnapshotForBottle
// and set that count to _count
+(NSNumber *)countOfBottle:(Bottle *)bottle forContext:(NSManagedObjectContext *)context {
    return [self countOfBottleForObjectID:bottle.objectID inContext:context];
}

+(NSNumber *)countOfWineBottle:(WineBottle *)wineBottle forContext:(NSManagedObjectContext *)context {
    return [self countOfBottleForObjectID:wineBottle.objectID inContext:context];
}

+(NSNumber *)countOfBottleForObjectID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InventorySnapshotForBottle" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"whichBottle == %@", [context objectWithID:objectID]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // We only want the most recent one
    [fetchRequest setFetchBatchSize:1];
    
    NSError * err = nil;
    NSArray * fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    InventorySnapshotForBottle * snapshot = [fetchedObjects lastObject];
    
    if (snapshot.count == nil) {
        return [NSNumber numberWithInt:0];
    } else {
        return snapshot.count;
    }
}

+(NSString *)cleanedSearchText:(NSString *)searchText {
    NSString * str = [searchText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
}

// pass any string and this will return a set of bottles matching any name or barcode in that string
// but restricted to the bottles in a particular order
+(NSSet *)bottlesFromSearchText:(NSString *)searchText withOrder:(Order *)order {
    searchText = [Bottle cleanedSearchText:searchText];
    NSNumber * fuzziness = [NSNumber numberWithInt:.9];
    NSMutableSet * foundBottles = [[NSMutableSet alloc] init]; // the final thing we will return
    NSArray * searchPieces = [searchText componentsSeparatedByString:@" "];

    // first, iterate through each order and do a simple check to see if
    // the name or barcode of that bottle is within the search text
    NSArray * bottleProps = [[NSArray alloc] initWithObjects:@"name", @"barcode", nil];
    BOOL found;
    NSSet * orders = order.ordersByBottle;

    for (OrderForBottle * order in orders) {
        found = NO;
        Bottle * bottle = order.whichBottle;

        // For each prop that we want to compare (name, barcode) do a few types of searches
        for (NSString * prop in bottleProps) {
            if (found) {continue;}

            // First do a basic exact match search over the whole search text
            NSString * value = [bottle valueForKey:prop]; // THIS BETTER BE A STRING
            if ([searchText rangeOfString:value].location != NSNotFound) {
//                NSLog(@"Exact: %@",value);
                found = YES;
                continue;
            }
            
            // Second, a FUZZY comparison on each piece of the search text
            for (NSString * piece in searchPieces) {
                CGFloat result = [value scoreAgainst:piece fuzziness:fuzziness];
//                NSLog(@"piece: %@ value: %@ score: %f", piece, value, result);
                if (result > .5) {
//                    NSLog(@"FOUND value: %@ from piece: %@", value, piece);
                    found = YES;
                    break;
                }
            }
        }
        
        if (found) {
            [foundBottles addObject:bottle];
        }
    }
    return foundBottles;
}

+(Producer *)newProducerForName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    Producer * producer = [NSEntityDescription insertNewObjectForEntityForName:@"Producer" inManagedObjectContext:context];
    producer.name = name;
    return producer;
}

+(Producer *)producerForName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Producer"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // get the results and print them
    NSError *err;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&err];
    Producer * producer = [fetchedObjects lastObject]; // should only be one anyways
    return producer;
}

@end
