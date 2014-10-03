//
//  PickOrderDelegate.h
//  Duck
//
//  Created by Scott Antipa on 10/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order+Create.h"

@protocol PickOrderDelegate <NSObject>
-(void)didSelectOrder:(Order *)order; // the picker picked an Order
-(BOOL)orderIsSelected:(Order *)order; // picker will put a check mark next to selected order
@end
