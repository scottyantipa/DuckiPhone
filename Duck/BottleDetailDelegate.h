//
//  BottleDetailDelegate.h
//  Duck
//
//  Created by Scott Antipa on 11/4/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bottle+Create.h"

@protocol BottleDetailDelegate <NSObject>
-(void)didFinishEditingBottle:(Bottle *)bottle;
@end
