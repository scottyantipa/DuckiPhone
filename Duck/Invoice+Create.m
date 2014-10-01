//
//  Invoice+Create.m
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "Invoice+Create.h"

@implementation Invoice (Create)

// NOTE this logic is duplicated for the most part in Order+Create
+(void)toggleBottle:(Bottle *)bottle inInvoice:(Invoice *)invoice inContext:(NSManagedObjectContext *)context {
    bool isSelected = NO;
    NSSet * bottlesInInvoice = invoice.invoicesByBottle;
    for (InvoiceForBottle * invoiceForBottle in bottlesInInvoice) {
        if ([invoiceForBottle.bottle.name isEqualToString:[NSString stringWithFormat:@"%@", bottle.name]]) { // there was an order for that bottle -- lets delete it
            isSelected = YES;
            [context deleteObject:invoiceForBottle];
            break; // note, it would be a bug if there are more than one orderesForBottle, so we are safe to break after 1
        }
    }
    if (!isSelected) {
        InvoiceForBottle * newInvoiceForBottle = [NSEntityDescription insertNewObjectForEntityForName:@"InvoiceForBottle" inManagedObjectContext:context];
        newInvoiceForBottle.invoice = invoice;
        newInvoiceForBottle.bottle = bottle;
        newInvoiceForBottle.quantity = [NSNumber numberWithFloat:0];
        newInvoiceForBottle.unitPrice = [NSNumber numberWithFloat:0];
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
