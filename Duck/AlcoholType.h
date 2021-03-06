//
//  AlcoholType.h
//  Duck
//
//  Created by Scott Antipa on 4/23/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlcoholSubType;

@interface AlcoholType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subTypes;
@end

@interface AlcoholType (CoreDataGeneratedAccessors)

- (void)addSubTypesObject:(AlcoholSubType *)value;
- (void)removeSubTypesObject:(AlcoholSubType *)value;
- (void)addSubTypes:(NSSet *)values;
- (void)removeSubTypes:(NSSet *)values;

@end
