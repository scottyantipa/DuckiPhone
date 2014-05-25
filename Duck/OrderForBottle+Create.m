//
//  OrderForBottle+Create.m
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "OrderForBottle+Create.h"

@implementation OrderForBottle (Create)

// Create a new order for a bottle
// Automatically populate the info from the most recent order into this one
// e.g. price and quantity, so user doesn't have to
+(OrderForBottle *)newOrderForBottle:(Bottle *)bottle
                                forOrder:(Order *)order
                  inManagedObjectContext:(NSManagedObjectContext *)context {

    // Get the most recent BEFORE creating a new one (otherwise the most recent will be the blank one created)
    OrderForBottle * mostRecentOrder = [Bottle mostRecentOrderForBottle:bottle inContext:context];
    OrderForBottle * orderForBottle = [NSEntityDescription insertNewObjectForEntityForName:@"OrderForBottle" inManagedObjectContext:context];
    orderForBottle.whichBottle = bottle;
    orderForBottle.whichOrder = order;

    // copy over the info from the most recent order
    orderForBottle.quantity = mostRecentOrder.quantity;
    orderForBottle.unitPrice = mostRecentOrder.unitPrice;

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return orderForBottle;
}
@end
