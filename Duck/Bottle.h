//
//  Bottle.h
//  Duck
//
//  Created by Scott Antipa on 1/15/15.
//  Copyright (c) 2015 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlcoholSubType, AlcoholType, InventorySnapshotForBottle, InvoiceForBottle, InvoicePhoto, OrderForBottle, Producer;

@interface Bottle : NSManagedObject

@property (nonatomic, retain) NSString * alcoholSubType;
@property (nonatomic, retain) NSString * alcoholType;
@property (nonatomic, retain) NSString * barcode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * producerName;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSNumber * userHasBottle;
@property (nonatomic, retain) NSNumber * userOrdering;
@property (nonatomic, retain) NSString * volume;
@property (nonatomic, retain) NSNumber * ranking;
@property (nonatomic, retain) NSSet *inventoryShapshots;
@property (nonatomic, retain) NSSet *invoicePhotos;
@property (nonatomic, retain) NSSet *invoicesForBottle;
@property (nonatomic, retain) NSSet *orders;
@property (nonatomic, retain) Producer *producer;
@property (nonatomic, retain) AlcoholSubType *subType;
@property (nonatomic, retain) AlcoholType *type;
@end

@interface Bottle (CoreDataGeneratedAccessors)

- (void)addInventoryShapshotsObject:(InventorySnapshotForBottle *)value;
- (void)removeInventoryShapshotsObject:(InventorySnapshotForBottle *)value;
- (void)addInventoryShapshots:(NSSet *)values;
- (void)removeInventoryShapshots:(NSSet *)values;

- (void)addInvoicePhotosObject:(InvoicePhoto *)value;
- (void)removeInvoicePhotosObject:(InvoicePhoto *)value;
- (void)addInvoicePhotos:(NSSet *)values;
- (void)removeInvoicePhotos:(NSSet *)values;

- (void)addInvoicesForBottleObject:(InvoiceForBottle *)value;
- (void)removeInvoicesForBottleObject:(InvoiceForBottle *)value;
- (void)addInvoicesForBottle:(NSSet *)values;
- (void)removeInvoicesForBottle:(NSSet *)values;

- (void)addOrdersObject:(OrderForBottle *)value;
- (void)removeOrdersObject:(OrderForBottle *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
