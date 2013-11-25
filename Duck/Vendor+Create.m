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
    return vendor;
}
@end
