//
//  InventorySnapshotForBottle+Create.h
//  Duck03
//
//  Created by Scott Antipa on 9/3/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "InventorySnapshotForBottle.h"
#import "WineBottle+Create.h"

@interface InventorySnapshotForBottle (Create)
+(InventorySnapshotForBottle *)newInventoryForBottleSnapshotForDate:(NSDate *)date
                                                          withCount:(NSNumber *)count
                                                          forBottle:(Bottle *)bottle
                                             inManagedObjectContext:(NSManagedObjectContext *)context;
+(InventorySnapshotForBottle *)newInventoryForBottleSnapshotForDate:(NSDate *)date withCount:(NSNumber *)count wineBottle:(WineBottle *)bottle inManagedObjectContext:(NSManagedObjectContext *)context;
@end
