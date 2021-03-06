//
//  Utils.h
//  Duck
//
//  Created by Scott Antipa on 11/18/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bottle+Create.h"
#import "WineBottle+Create.h"
#import "LiquorBottle.h"
#import "BeerBottle.h"

@interface Utils : NSObject
+(void)markSubviewsAsNoDelay:(UIView *)view;
+(UIColor *)lighterColorForColor:(UIColor *)c byPercent:(CGFloat)percent;
+(UIColor *)darkerColorForColor:(UIColor *)c byPercent:(CGFloat)percent;
+(UIImage *)imageWithColor:(UIColor *)color;
+(NSArray *)volumesForBottleClass:(Class)bottleClass;
@end
