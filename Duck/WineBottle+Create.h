//
//  WineBottle+Create.h
//  Duck
//
//  Created by Scott Antipa on 11/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "WineBottle.h"
#import "Varietal.h"
#import "Producer.h"

@interface WineBottle (Create)
+(NSOrderedSet *)whiteList; // extends Bottle whitelist, this should be a typedef
-(NSString *)name;
@end
