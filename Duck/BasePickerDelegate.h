//
//  BasePickerDelegate.h
//  Duck
//
//  Created by Scott Antipa on 12/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BasePickerDelegate <NSObject>
-(void)didFinishPickingWithValue:(NSString *)value;
@end
