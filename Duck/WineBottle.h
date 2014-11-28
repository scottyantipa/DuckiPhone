//
//  WineBottle.h
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Bottle.h"

@class Varietal, Vineyard;

@interface WineBottle : Bottle

@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) Varietal *varietal;
@property (nonatomic, retain) Vineyard *vineyard;

@end
