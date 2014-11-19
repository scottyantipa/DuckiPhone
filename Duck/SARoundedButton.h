//
//  SARoundedButton.h
//  Duck
//
//  Created by Scott Antipa on 11/18/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface SARoundedButton : UIButton
@property (weak) UIColor * mainColor;
@property (weak) NSString * title;
@property CGFloat cornerRadius;
-(void)setup;
@end
