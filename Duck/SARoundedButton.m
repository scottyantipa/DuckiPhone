//
//  SARoundedButton.m
//  Duck
//
//  Created by Scott Antipa on 11/18/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

//
// This creates a rounded rect button which animates its background color on touchUp
//

#import "SARoundedButton.h"

@implementation SARoundedButton

@synthesize mainColor = _mainColor;
@synthesize title = _title;
@synthesize cornerRadius = _cornerRadius;

-(void)setup {
    self.layer.masksToBounds = YES;
    // title color/alignemnt
    [self setTitleColor:_mainColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[Utils imageWithColor:_mainColor] forState:UIControlStateHighlighted];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setTitle:_title forState:UIControlStateNormal];
    
    // border color/sizing
    self.layer.borderColor = _mainColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = _cornerRadius;
    
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchUp {
    [self animate];
}

// animate the background color to _mainColor, then animate it back to clear
- (void)animate
{
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.1f
                          delay: 0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.layer.backgroundColor = _mainColor.CGColor;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay: 0
                                             options: UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                             self.titleLabel.textColor = _mainColor;
                                             self.layer.backgroundColor = [UIColor clearColor].CGColor;
                                          }
                                        completion:nil
                         ];
                     }];
    
    [self setNeedsDisplay];
}

@end
