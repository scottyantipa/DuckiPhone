//
//  Invoice.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InvoiceForBottle, InvoicePhoto, Order, Vendor;

@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSDate * dateReceived;
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *invoicesByBottle;
@property (nonatomic, retain) Vendor *vendor;
@end

@interface Invoice (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(InvoicePhoto *)value;
- (void)removePhotosObject:(InvoicePhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addInvoicesByBottleObject:(InvoiceForBottle *)value;
- (void)removeInvoicesByBottleObject:(InvoiceForBottle *)value;
- (void)addInvoicesByBottle:(NSSet *)values;
- (void)removeInvoicesByBottle:(NSSet *)values;

@end
