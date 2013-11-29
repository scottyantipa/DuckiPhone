//
//  Order+Create.h
//  Duck03
//
//  Created by Scott Antipa on 9/17/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Order.h"
#import "OrderForBottle+Create.h"
#import "Vendor.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Order (Create)
+(Order *)newOrderForDate:(NSDate *)date
            inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)getSortedBottlesInOrder:(Order *)order;
+(float)totalAmountOfOrder:(Order *)order;
+(MFMailComposeViewController *)mailComposeForOrder:(Order *)order;

// Either add or remove an orderForBottle from the Order (e.g. when a user toggles that bottle in the
// order table view controller)
+(void)toggleBottle:(Bottle *)bottle inOrder:(Order *)order inContext:(NSManagedObjectContext *)context;

+(NSString *)errorStringForSendingIncompleteOrder:(Order *)order;
@end
