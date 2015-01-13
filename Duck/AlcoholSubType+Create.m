//
//  AlcoholSubType+Create.m
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "AlcoholSubType+Create.h"

@implementation AlcoholSubType (Create)

// Gets the managed object for the alcohol type with the given name
// If there isn't one already in existence (or the name is "") then create one
+(AlcoholSubType *)alcoholSubTypeFromName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AlcoholSubType"];
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
    
    // if none were returned, then create one
    if ([fetchedObjects count] == 0) {
        AlcoholSubType *newSubType = [AlcoholSubType newSubTypeFromName:@"New Bottle" inManagedObjectContext:context];
        return newSubType;
    }
    else {
        AlcoholSubType *subType = [fetchedObjects lastObject];
        return subType;
    }
    
}

+(AlcoholSubType *)newSubTypeFromName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    AlcoholSubType *subType = [NSEntityDescription
                               insertNewObjectForEntityForName:@"AlcoholSubType"
                               inManagedObjectContext:context];
    subType.name = name;
    // need to add in unique id here
    return subType;
}

// This should probably go in a Varietal+Create but fuck it for now
+(Varietal *)newVarietalForSubType:(AlcoholSubType *)subType inContext:(NSManagedObjectContext *)context {
    Varietal * varietal = [NSEntityDescription insertNewObjectForEntityForName:@"Varietal" inManagedObjectContext:context];
    varietal.subType = subType;
    return varietal;
}

+(Varietal *)varietalForName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Varietal"];
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
    Varietal * varietal = [fetchedObjects lastObject]; // should only be one anyways
    return  varietal;
}

+(NSArray *)fetchedBottlesForSubType:(AlcoholSubType *)subType inContext:(NSManagedObjectContext *)context {
    NSString * subTypeName = subType.name;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bottle"];
    
    // Fetch the bottles that the user has.  We will adjust their userOrdering when the user
    // adds/removes a bottle
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subType.name = %@) AND (self.userHasBottle = %@)", subTypeName, [NSNumber numberWithBool:YES]];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *err;
    return [context executeFetchRequest:fetchRequest error:&err];
}

+(NSArray *)fetchedBottlesForVarietal:(Varietal *)varietal inContext:(NSManagedObjectContext *)context {
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"WineBottle"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(varietal = %@) AND (self.userHasBottle = %@)", varietal.name, [NSNumber numberWithBool:YES]];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userOrdering" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *err;
    return [context executeFetchRequest:fetchRequest error:&err];
}

@end
