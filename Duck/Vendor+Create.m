//
//  Vendor+Create.m
//  Duck
//
//  Created by Scott Antipa on 11/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Vendor+Create.h"

@implementation Vendor (Create)
+(Vendor *)newVendorInContext:(NSManagedObjectContext *)context {
    Vendor * vendor = [NSEntityDescription insertNewObjectForEntityForName:@"Vendor" inManagedObjectContext:context];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    return vendor;
}
+(NSString *)fullNameOfVendor:(Vendor *)vendor {
    if ((vendor.firstName) && (vendor.lastName)) {
        return [NSString stringWithFormat:@"%@ %@", vendor.firstName, vendor.lastName];
    } else {
        return NO;
    }
}

// When user picks a vendor from their address book, we need to store it
+(Vendor *)newVendorForRef:(ABRecordRef)vendorRef inContext:(NSManagedObjectContext *)context {
    Vendor * vendor = [Vendor newVendorInContext:context];
    vendor.firstName = (__bridge NSString *)ABRecordCopyValue(vendorRef, kABPersonFirstNameProperty);
    vendor.lastName = (__bridge NSString *)ABRecordCopyValue(vendorRef, kABPersonLastNameProperty);

    // get the first email and store it
    ABMutableMultiValueRef multi = ABRecordCopyValue(vendorRef, kABPersonEmailProperty);
    NSString * email;
    for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
        if (i == 0) {
            email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multi, i));
            break;
        } else {
            break;
        }
    }
    vendor.email = email;
    
    // get first phone and store it
    NSString * phone;
    ABMultiValueRef multiPhones = ABRecordCopyValue(vendorRef, kABPersonPhoneProperty);
    for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
        if (i == 0) {
            phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multiPhones, i));
        }
    }
    vendor.phone = phone;
    return vendor;
}

// When user wants to re-order, we need to update the Vendor
// associated with the order.  If we find the Vendor in their Address book,
// just update the Vendor and return YES.  If we can't find it in the
// Address book, delete the Vendor and return NO (user will select a new one)
// NOTE: DONT CHECK FIRST NAME -- it is too comomon
+(BOOL)updateVendorFromAddressBook:(Vendor *)vendor {
    NSString * lastName = vendor.lastName;
    NSString * email = vendor.email;
    NSArray * allVendorTraits = @[lastName, email];
    
    int highestNumberOfCommonTraits = 0; // number of traits shared with the most similar vendor

    // the address contact info we care about (will update these as we loop through contacts)
    NSString * closestLastName;
    NSString * closestEmail;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    for ( int i = 0; i < nPeople; i++ ) { // looping through contact book
        // get last name
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        NSString * refLastName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if (!refLastName) {
            NSLog(@"continuing because last name is %@", refLastName);
            continue;
        }

        // get email
        ABMutableMultiValueRef multi = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSString * refEmail;
        for (CFIndex j = 0; j < ABMultiValueGetCount(multi); j++) {
            if (j == 0) {
                refEmail = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multi, j));
                break;
            } else {
                break;
            }
        }
        if (!refEmail) {
            NSLog(@"continuing because email is %@", refEmail);
            continue;
        }
        

        NSMutableArray * allTraits = [[NSMutableArray alloc] initWithArray:@[refLastName, refEmail]];
        int numCommonTraits = 0;
        
        // Run through traits of the main vendor and this contact
        // and count what traits they have in common
        for (CFIndex k = 0; k < [allVendorTraits count]; k++) {
            NSString * vendorTrait = [allVendorTraits objectAtIndex:k];
            NSString * personTrait = [allTraits objectAtIndex:k];
            if ([vendorTrait isEqualToString:personTrait]) {
                numCommonTraits++;
            }
        }
        if (numCommonTraits > highestNumberOfCommonTraits) { // this ref is now the most similar
            highestNumberOfCommonTraits = numCommonTraits;
            closestLastName = refLastName;
            closestEmail = refEmail;
        }
        if (numCommonTraits == 2) { // this is an exact match, stop looking (lastName, email)
            break;
        }
    }
    
    // Now we have our most similar person.  Update the vendor with this information.
    if (highestNumberOfCommonTraits == 2) { // a perfect match (lastName, email)
        return YES;
    } else if (highestNumberOfCommonTraits > 0) { // We found the right person, now update the Vendor to match it
        vendor.lastName = closestLastName;
        vendor.email = closestEmail;
        return YES;
    } else { // we didn't find anyone in the address book
        return NO;
    }

}
@end
