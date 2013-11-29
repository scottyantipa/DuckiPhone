//
//  Vendor.h
//  Duck
//
//  Created by Scott Antipa on 11/27/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Vendor : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Order *whichOrder;

@end
