//
//  Order+Create.m
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Order+Create.h"


@implementation Order (Create)
+(Order *)newOrderForDate:(NSDate *)date
   inManagedObjectContext:(NSManagedObjectContext *)context {
    Order * order = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Order"
                               inManagedObjectContext:context];
    order.date = date;
    return order;
}

+(NSArray *)getSortedBottlesInOrder:(Order *)order {
    NSSet * bottlesInOrder = order.ordersByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whichBottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    return [bottlesInOrder sortedArrayUsingDescriptors:sortDescriptors];
}


+(float)totalAmountOfOrder:(Order *)order {
    NSArray * sortedBottleOrders = [Order getSortedBottlesInOrder:order];
    float totalAmount = 0;
    for (OrderForBottle * order in sortedBottleOrders) {
        float floatPrice = [order.unitPrice floatValue];
        float floatQuantity = [order.quantity floatValue];
        float totalForBottleOrder = floatPrice * floatQuantity;
        totalAmount = totalAmount + totalForBottleOrder;
    }
    return totalAmount;
}

+(void)toggleBottle:(Bottle *)bottle inOrder:(Order *)order inContext:(NSManagedObjectContext *)context {
    bool isSelected = NO;
    NSSet * bottlesInOrder = order.ordersByBottle;
    for (OrderForBottle * orderForBottle in bottlesInOrder) {
        if ([orderForBottle.whichBottle.name isEqualToString:[NSString stringWithFormat:@"%@", bottle.name]]) { // there was an order for that bottle -- lets delete it
            isSelected = YES;
            [context deleteObject:orderForBottle];
            break; // note, it would be a bug if there are more than one orderesForBottle, so we are safe to break after 1
        }
    }
    if (!isSelected) {
        [OrderForBottle newOrderForBottle:bottle forOrder:order inManagedObjectContext:context];
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(MFMailComposeViewController *)mailComposeForOrder:(Order *)order {
    NSSet * bottlesInOrder = order.ordersByBottle;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"whichBottle.name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSArray * sortedBottlesInOrder = [bottlesInOrder sortedArrayUsingDescriptors:sortDescriptors];
    NSString * vendorName = order.whichVendor.name;
    NSString * greeting = [NSString stringWithFormat:@"Hello %@,\n\nI would like to place an order with you as described below:", vendorName];
    NSMutableArray * bottleStrings = [[NSMutableArray alloc] init];
    
    // Create the string for this bottle order (bottle name, price, quantity)
    for (OrderForBottle * orderForBottle in sortedBottlesInOrder) {
        NSString * name = [NSString stringWithFormat:@"Bottle: %@", orderForBottle.whichBottle.name];
        NSString * quantity = [NSString stringWithFormat:@"Qty: %g", [orderForBottle.quantity floatValue]];
        NSString * price = [NSString stringWithFormat:@"Unit Price: %g", [orderForBottle.unitPrice floatValue]];
        NSString * blockForBottle = [NSString stringWithFormat:@"%@\n%@\n%@", name, quantity, price];
        
        [bottleStrings addObject:blockForBottle];
    }

    NSString * allBottles = [bottleStrings componentsJoinedByString:@"\n\n"];
    NSString * signOff = [NSString stringWithFormat:@"Thank you. \n\nPowered by Duck Rows"];

    NSString * body = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", greeting, allBottles, signOff];

    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setSubject:@"New Order"];
    [mailViewController setMessageBody:body isHTML:NO];
    return mailViewController;
}
@end
