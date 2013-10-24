//
//  Vendor.h
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Vendor : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Order *whichOrder;

@end
