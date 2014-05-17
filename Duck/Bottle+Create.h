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
#import "NSString+Score.h"


@interface Bottle (Create)
+(NSOrderedSet *)whiteList;
+(Bottle *)bottleForName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)bottleForBarcode:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)newBottleForBarcode:(NSString *)barcode inManagedObjectContext:(NSManagedObjectContext *)context;
+(Bottle *)newBlankBottleInContext:(NSManagedObjectContext *)context;
+(void)toggleUserHasBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context;
+(OrderForBottle *)mostRecentOrderForBottle:(Bottle *)bottle inContext:(NSManagedObjectContext *)context;
+(NSSet *)bottlesFromSearchText:(NSString *)searchText;
+(NSSet *)bottlesFromSearchText:(NSString *)searchText withOrder:(Order *)order;
+(NSString *)cleanedSearchText:(NSString *)searchText;
@end
