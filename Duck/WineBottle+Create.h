//
//  WineBottle+Create.h
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "WineBottle.h"
#import "Vineyard.h"

@interface WineBottle (Create)
// these vineyard methods should be put in a Vineyard+Create
+(Vineyard *)newVineyardForName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+(Vineyard *)vineyardForName:(NSString *)name inContext:(NSManagedObjectContext *)context;
@end
