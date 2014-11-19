//
//  Utils.m
//  Duck
//
//  Created by Scott Antipa on 11/18/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void)markSubviewsAsNoDelay:(UIView *)view {
    if ([[view class] isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)view).delaysContentTouches = NO;
    } else {
        for (UIView *subView in view.subviews) {
            [Utils markSubviewsAsNoDelay:subView];
        }
    }
}


// These should really be in a UIColor category and were stollen from here: http://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor
+(UIColor *)lighterColorForColor:(UIColor *)c byPercent:(CGFloat)percent
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + percent, 1.0)
                               green:MIN(g + percent, 1.0)
                                blue:MIN(b + percent, 1.0)
                               alpha:a];
    return nil;
}

+(UIColor *)darkerColorForColor:(UIColor *)c byPercent:(CGFloat)percent
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - percent, 0.0)
                               green:MAX(g - percent, 0.0)
                                blue:MAX(b - percent, 0.0)
                               alpha:a];
    return nil;
}

// stole this from here: http://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
