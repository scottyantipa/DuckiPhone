//
//  WineBottle.h
//  Duck
//
//  Created by Scott Antipa on 1/13/15.
//  Copyright (c) 2015 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Bottle.h"

@class Varietal;

@interface WineBottle : Bottle

@property (nonatomic, retain) NSString * varietalName;
@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSString * producerName;
@property (nonatomic, retain) Varietal *varietal;

@end
