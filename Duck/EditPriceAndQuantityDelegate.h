//
//  EditPriceAndQuantityDelegate.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditPriceAndQuantityDelegate <NSObject>
-(void)didFinishEditingPrice:(NSNumber *)price forObject:(id)obj;
-(NSNumber *)priceOfObj:(id)obj;

-(void)didFinishEditingQuantity:(NSNumber *)qty forObject:(id)obj;
-(NSNumber *)quantityOfObj:(id)obj;

-(NSString *)nameOfObject:(id)obj;
@end
