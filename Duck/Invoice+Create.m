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
        InvoiceForBottle * mostRecent = [Bottle mostRecentInvoiceForBottle:bottle inContext:context];
        InvoiceForBottle * newInvoiceForBottle = [NSEntityDescription insertNewObjectForEntityForName:@"InvoiceForBottle" inManagedObjectContext:context];
        newInvoiceForBottle.invoice = invoice;
        newInvoiceForBottle.bottle = bottle;
        newInvoiceForBottle.quantity = mostRecent ? mostRecent.quantity : 0;
        newInvoiceForBottle.unitPrice = mostRecent ? mostRecent.unitPrice : 0;
        bottle.userHasBottle = [NSNumber numberWithBool:YES]; // auto add it to their collection        
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(Invoice *)newBlankInvoiceInContext:(NSManagedObjectContext *)context {
    Invoice * invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:context];
    invoice.vendor = [Vendor newVendorInContext:context];
    return invoice;
}

+(MFMailComposeViewController *)mailComposeForBottleRefund:(Bottle *)bottle fromOriginalPrice:(NSNumber *)originalPrice withBottleInvoices:(NSArray *)bottleInvoices forLossOf:(NSNumber *)loss {

    // setup number and date formatters
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    
    InvoiceForBottle * last = [bottleInvoices lastObject];
    Vendor * vendor = last.invoice.vendor;
    NSArray * toRecipients = @[vendor.email];
    

    NSString * greeting = [NSString stringWithFormat:@"%@\n\nIt has come to my attention that there have been price variations over several orders I have made for the bottle %@.  When considering the number of units I have purchased, these price variations have resulted in the following dollar amount in excess cumulative charges: %@.  I would appreciate your response to this refund request either by email or phone.  Thank you.", vendor.firstName, bottle.name, [numberFormatter stringFromNumber:loss]];
    
    NSMutableArray * invoiceDescriptions = [[NSMutableArray alloc] init];
    for (InvoiceForBottle * bottleInvoice in bottleInvoices) {
        NSString * dateString = [dateFormatter stringFromDate:bottleInvoice.invoice.dateReceived];
        NSString * description = [NSString stringWithFormat:@"\nUnit price: %@\nQty: %@\n%@", [numberFormatter stringFromNumber:bottleInvoice.unitPrice], bottleInvoice.quantity, dateString];
        [invoiceDescriptions addObject:description];
    }
    
    NSString * allDescriptions = [invoiceDescriptions componentsJoinedByString:@"\n\n"];
    NSString * body = [NSString stringWithFormat:@"%@\n\n%@", greeting, allDescriptions];
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setToRecipients:toRecipients];
    [mailViewController setSubject:@"Requesting refund"];
    [mailViewController setMessageBody:body isHTML:NO];
    return mailViewController;
}

+(float)totalAmountofInvoice:(Invoice *)invoice {
    float total = 0;
    for (InvoiceForBottle * i in invoice.invoicesByBottle){
        total +=  [i.unitPrice floatValue] * [i.quantity floatValue];
    }
    return total;
}

+(NSString *)contentsDescriptionForInvoice:(Invoice *)invoice {
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSString * total = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[Invoice totalAmountofInvoice:invoice]]];
    return [NSString stringWithFormat:@"%d skus totalling %@", invoice.invoicesByBottle.count, total];
}

@end
