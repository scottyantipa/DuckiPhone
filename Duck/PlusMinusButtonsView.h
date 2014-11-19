//
//  PlusMinusButtonsView.h
//  Duck
//
//  Created by Scott Antipa on 11/17/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SARoundedButton.h"

@interface PlusMinusButtonsView : UIView
+(void)setupView:(PlusMinusButtonsView *)view;
+(void)formatButton:(SARoundedButton *)button forPlus:(bool)isPlus;
+(int)viewWidth;
+(int)buttonHeight;
@property (strong, nonatomic) SARoundedButton * plus1Button;
@property (strong, nonatomic) SARoundedButton * plus5Button;
@property (strong, nonatomic) SARoundedButton * minus1Button;
@property (strong, nonatomic) SARoundedButton * minus5Button;
@property (strong, nonatomic) NSArray * values;
@end