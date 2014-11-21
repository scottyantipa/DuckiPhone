//
//  WineBottle.h
//  Duck
//
//  Created by Scott Antipa on 11/20/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Bottle.h"


@interface WineBottle : Bottle

@property (nonatomic, retain) NSNumber * vintage;
@property (nonatomic, retain) NSManagedObject *varietal;
@property (nonatomic, retain) NSManagedObject *vineyard;

@end
