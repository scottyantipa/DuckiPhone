//
//  PickProducerDelegate.h
//  Duck
//
//  Created by Scott Antipa on 12/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Producer.h"

@protocol PickProducerDelegate <NSObject>
-(void)didFinishPickingProducer:(Producer *)producer;
@end
