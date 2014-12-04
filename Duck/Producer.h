//
//  Producer.h
//  Duck
//
//  Created by Scott Antipa on 12/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bottle;

@interface Producer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bottles;
@end

@interface Producer (CoreDataGeneratedAccessors)

- (void)addBottlesObject:(Bottle *)value;
- (void)removeBottlesObject:(Bottle *)value;
- (void)addBottles:(NSSet *)values;
- (void)removeBottles:(NSSet *)values;

@end
