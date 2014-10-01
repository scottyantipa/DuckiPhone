//
//  Invoice+Create.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "Invoice.h"
#import "Bottle+Create.h"
#import "Invoice.h"
#import "InvoiceForBottle.h"

@interface Invoice (Create)
+(void)toggleBottle:(Bottle *)bottle inInvoice:(Invoice *)invoice inContext:(NSManagedObjectContext *)context;
@end
