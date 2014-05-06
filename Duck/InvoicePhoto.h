//
//  InvoicePhoto.h
//  Duck
//
//  Created by Scott Antipa on 5/5/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bottle, Invoice;

@interface InvoicePhoto : NSManagedObject

@property (nonatomic, retain) NSString * documentName;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Invoice *invoice;
@property (nonatomic, retain) NSSet *bottles;
@end

@interface InvoicePhoto (CoreDataGeneratedAccessors)

- (void)addBottlesObject:(Bottle *)value;
- (void)removeBottlesObject:(Bottle *)value;
- (void)addBottles:(NSSet *)values;
- (void)removeBottles:(NSSet *)values;

@end
