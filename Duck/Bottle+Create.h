//
//  Bottle+Create.h
//  Duck03
//
//  Created by Scott Antipa on 8/25/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Bottle.h"
#import "OrderForBottle+Create.h"
#import "AlcoholSubType+Create.h"
#import "InventorySnapshotForBottle+Create.h"
#import "Order+Create.h"

@interface Bottle (Create)
+(NSOrderedSet *)whiteList;
+(Bottle *)bottleForName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)bottleForBarcode:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)newBottleForBarcode:(NSString *)barcode inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)newBlankBottleInContext:(NSManagedObjectContext *)context;
+(OrderForBottle *)mostRecentOrderForBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context;

// pass any string and this will search all possible bottles returning a set of bottles
// found in that string (name, barcode, etc.)
+(NSSet *)bottlesFromSearchText:(NSString *)searchText;

// pass any string and this will return a set of bottles matching any name or barcode in that string
// but restricted to the bottles in a particular order
+(NSSet *)bottlesFromSearchText:(NSString *)searchText withOrder:(Order *)order;
@end
