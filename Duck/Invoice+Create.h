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
#import "Vendor+Create.h"
#import "InvoiceForBottle.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface Invoice (Create)
+(void)toggleBottle:(Bottle *)bottle inInvoice:(Invoice *)invoice inContext:(NSManagedObjectContext *)context;
+(Invoice *)newBlankInvoiceInContext:(NSManagedObjectContext *)context;
+(MFMailComposeViewController *)mailComposeForBottleRefund:(Bottle *)bottle fromOriginalPrice:(NSNumber *)originalPrice withBottleInvoices:(NSArray *)bottleInvoices forLossOf:(NSNumber *)loss;
@end
