//
//  WineBottle+Create.m
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "WineBottle+Create.h"

@implementation WineBottle (Create)
// note that this is not a direct superset of [Bottle whiteList] so there are repetitions
+(NSOrderedSet *)whiteList;
{
    return [NSOrderedSet orderedSetWithObjects:@"producer", @"varietal", @"volume", @"count", @"barcode", nil];
}
-(NSString *)name {
    return [self.producer.name stringByAppendingString:[NSString stringWithFormat:@" %@", self.varietal.name]];
}

@end
