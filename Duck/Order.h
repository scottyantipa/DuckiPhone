//
//  Order.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invoice, OrderForBottle, Vendor;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * arrived;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * sent;
@property (nonatomic, retain) NSNumber * totalAmount;
@property (nonatomic, retain) NSSet *invoices;
@property (nonatomic, retain) NSSet *ordersByBottle;
@property (nonatomic, retain) Vendor *whichVendor;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addInvoicesObject:(Invoice *)value;
- (void)removeInvoicesObject:(Invoice *)value;
- (void)addInvoices:(NSSet *)values;
- (void)removeInvoices:(NSSet *)values;

- (void)addOrdersByBottleObject:(OrderForBottle *)value;
- (void)removeOrdersByBottleObject:(OrderForBottle *)value;
- (void)addOrdersByBottle:(NSSet *)values;
- (void)removeOrdersByBottle:(NSSet *)values;

@end
