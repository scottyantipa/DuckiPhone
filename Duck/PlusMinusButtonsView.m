//
//  PlusMinusButtonsView.m
//  Duck
//
//  Created by Scott Antipa on 11/17/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "PlusMinusButtonsView.h"

@implementation PlusMinusButtonsView
@synthesize values = _values;
@synthesize plus1Button = _plus1Button;
@synthesize plus5Button = _plus5Button;
@synthesize minus1Button = _minus1Button;
@synthesize minus5Button = _minus5Button;

const int BUTTON_SPACING = 7;

+(int)buttonHeight {
    return 45.0;
}

+(int)viewWidth {
    return 4 * ([PlusMinusButtonsView buttonHeight] + BUTTON_SPACING);
}

+(void)setupView:(PlusMinusButtonsView *)view {
    view.values = @[@-5, @-1, @1, @5];
    int height = [PlusMinusButtonsView buttonHeight];
    SARoundedButton * button;
    for (NSNumber * value in view.values) {
        int order = [view.values indexOfObject:value];
        int xOffset = order * (height + BUTTON_SPACING);
        button = [[SARoundedButton alloc] initWithFrame:CGRectMake(xOffset, 0, height, height)];
        NSString * title = [value floatValue] > 0 ? [NSString stringWithFormat:@"+%@", value] : [NSString stringWithFormat:@"%@", value];
        [button setTitle:title];
        bool isPositive = [value integerValue] > 0;
        [PlusMinusButtonsView formatButton:button forPlus:isPositive];
        [button setup];
        switch (order) {
            case 0:
                if (view.minus5Button == nil) {
                    view.minus5Button = button;
                    [view addSubview:view.minus5Button];
                }
                break;
            case 1:
                if (view.minus1Button == nil) {
                    view.minus1Button = button;
                    [view addSubview:view.minus1Button];
                }
                break;
            case 2:
                if (view.plus1Button == nil) {
                    view.plus1Button = button;
                    [view addSubview:view.plus1Button];
                }
                break;
            case 3:
                if (view.plus5Button == nil) {
                    view.plus5Button = button;
                    [view addSubview:view.plus5Button];
                }
                break;
            default:
                break;
        }
    }
}

+(void)formatButton:(SARoundedButton *)button forPlus:(bool)isPlus {
    UIColor * green = [UIColor colorWithRed:0 green:.7 blue:.3 alpha:1];
    UIColor * red = [UIColor colorWithRed:.7 green:0 blue:.2 alpha:1];
    UIColor * color = isPlus ? green : red;
    [button setMainColor:color];
    button.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setCornerRadius:button.frame.size.width/2];
}




@end