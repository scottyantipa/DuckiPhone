//
//  InvoiceForBottle.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bottle, Invoice;

@interface InvoiceForBottle : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * unitPrice;
@property (nonatomic, retain) Invoice *invoice;
@property (nonatomic, retain) Bottle *bottle;

@end
