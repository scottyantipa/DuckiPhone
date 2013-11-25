//
//  Vendor.h
//  Duck
//
//  Created by Scott Antipa on 11/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Vendor : NSManagedObject

@property (nonatomic, retain) NSNumber * recordID;
@property (nonatomic, retain) Order *whichOrder;

@end
