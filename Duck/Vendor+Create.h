//
//  Vendor+Create.h
//  Duck
//
//  Created by Scott Antipa on 11/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Vendor.h"
#import <AddressBook/AddressBook.h>

@interface Vendor (Create)
+(Vendor *)newVendorInContext:(NSManagedObjectContext *)context;
+(NSString *)fullNameOfVendor:(Vendor *)vendor;
+(Vendor *)newVendorForRef:(ABRecordRef)vendorRef inContext:(NSManagedObjectContext *)context;
+(BOOL)updateVendorFromAddressBook:(Vendor *)vendor;
+(void)setDefaultValues:(Vendor *)vendor;
@end
