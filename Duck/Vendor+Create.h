//
//  Vendor+Create.h
//  Duck
//
//  Created by Scott Antipa on 11/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "Vendor.h"

@interface Vendor (Create)
+(Vendor *)newVendorInContext:(NSManagedObjectContext *)context;
@end
