//
//  Varietal.h
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlcoholSubType, WineBottle;

@interface Varietal : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) AlcoholSubType *subType;
@property (nonatomic, retain) NSSet *wines;
@end

@interface Varietal (CoreDataGeneratedAccessors)

- (void)addWinesObject:(WineBottle *)value;
- (void)removeWinesObject:(WineBottle *)value;
- (void)addWines:(NSSet *)values;
- (void)removeWines:(NSSet *)values;

@end
