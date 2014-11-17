//
//  PlusMinusButtonsView.h
//  Duck
//
//  Created by Scott Antipa on 11/17/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PlusMinusButtonsView : UIView
+(void)setupView:(PlusMinusButtonsView *)view;
+(void)formatButton:(UIButton *)button forPlus:(bool)isPlus;
+(int)viewWidth;
+(int)buttonHeight;
@property (strong, nonatomic) UIButton * plus1Button;
@property (strong, nonatomic) UIButton * plus5Button;
@property (strong, nonatomic) UIButton * minus1Button;
@property (strong, nonatomic) UIButton * minus5Button;
@property (strong, nonatomic) NSArray * values;
@end