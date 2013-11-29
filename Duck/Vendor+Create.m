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
    NSString * phone = vendor.phone;
    NSArray * allVendorTraits = @[lastName, email, phone];
    
    // Set up our variables that we will increment
    int highestNumberOfCommonTraits = 0; //
    NSString * closestLastName;
    NSString * closestEmail;
    NSString * closestPhone;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    for ( int i = 0; i < nPeople; i++ ) {
        
        //
        // Get traits for this ref
        //
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        NSString * refLastName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);

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
        
        // get first phone and store it
        NSString * refPhone;
        ABMultiValueRef multiPhones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            if (i == 0) {
                refPhone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multiPhones, i));
                break;
            }
        }
        
        
        NSMutableArray * allTraits = @[refLastName, refEmail, refPhone];
        int numCommonTraits = 0;
        
        // Run through traits of the main vendor and this contact
        // and count what traits they have in common
        for (CFIndex k = 0; k < [allVendorTraits count]; k++) {
            NSString * vendorTrait = [allVendorTraits objectAtIndex:k];
            NSString * personTrait = [allTraits objectAtIndex:k];
            if ([vendorTrait isEqualToString:personTrait]) {
//                NSLog(@"incrementing because %@ equals %@", vendorTrait, personTrait);
                numCommonTraits++;
            }
        }
        if (numCommonTraits > highestNumberOfCommonTraits) { // this ref is now the most similar
            highestNumberOfCommonTraits = numCommonTraits;
            closestLastName = refLastName;
            closestEmail = refEmail;
            closestPhone = refPhone;
        }
    }
    
    // Now we have our most similar person.  Update the vendor with this information.
    if (highestNumberOfCommonTraits == 3) { // someone in the address book shared all of the traits
//        NSLog(@"We found an exact match with lastName(%@)", closestLastName);
        return YES;
    } else if (highestNumberOfCommonTraits > 0) { // We found the right person, now update the Vendor to match it
//        NSLog(@"We found the right Vendor:  last(%@) email(%@) phone(%@", closestLastName, closestEmail, closestPhone);
        vendor.lastName = closestLastName;
        vendor.email = closestEmail;
        vendor.phone = closestPhone;
        return YES;
    } else { // we didn't find anyone in the address book
//        NSLog(@"We didn't find anyone as a match");
        return NO;
    }

}
@end
