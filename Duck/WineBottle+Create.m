//
//  WineBottle+Create.m
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "WineBottle+Create.h"

@implementation WineBottle (Create)
// note that this is not a direct superset of [Bottle whiteList] so there are repetitions
+(NSOrderedSet *)whiteList;
{
    return [NSOrderedSet orderedSetWithObjects:@"vineyard", @"varietal", @"volume", @"count", @"barcode", nil];
}

+(Vineyard *)newVineyardForName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    Vineyard * vineyard = [NSEntityDescription insertNewObjectForEntityForName:@"Vineyard" inManagedObjectContext:context];
    vineyard.name = name;
    return vineyard;
}

+(Vineyard *)vineyardForName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Vineyard"];
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
    Vineyard * vineyard = [fetchedObjects lastObject]; // should only be one anyways
    return vineyard;
}

-(NSString *)name {
    return [self.vineyard.name stringByAppendingString:[NSString stringWithFormat:@" %@", self.varietal.name]];
}

@end
