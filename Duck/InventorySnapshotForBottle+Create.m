//
//  InventorySnapshotForBottle+Create.m
//  Duck03
//
//  Created by Scott Antipa on 9/3/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "InventorySnapshotForBottle+Create.h"
#import "Bottle+Create.h"

@implementation InventorySnapshotForBottle (Create)

//
// Super code repeat below, but not sure how to resolve it
//

+(InventorySnapshotForBottle *)newInventoryForBottleSnapshotForDate:(NSDate *)date
                                                          withCount:(NSNumber *)count
                                                          forBottle:(Bottle *)bottle
                                             inManagedObjectContext:(NSManagedObjectContext *)context
{
    InventorySnapshotForBottle * snapShot = [NSEntityDescription insertNewObjectForEntityForName:@"InventorySnapshotForBottle" inManagedObjectContext:context];
    snapShot.date = date;
    snapShot.whichBottle = bottle;
    snapShot.count = count;
    return snapShot;
}

+(InventorySnapshotForBottle *)newInventoryForBottleSnapshotForDate:(NSDate *)date withCount:(NSNumber *)count wineBottle:(WineBottle *)bottle inManagedObjectContext:(NSManagedObjectContext *)context {

    InventorySnapshotForBottle * snapShot = [NSEntityDescription insertNewObjectForEntityForName:@"InventorySnapshotForBottle" inManagedObjectContext:context];
    snapShot.date = date;
    snapShot.whichBottle = bottle;
    snapShot.count = count;
    return snapShot;
}
@end
