//
//  CMPopTipViewStyleOverride.m
//  Duck
//
//  Created by Scott Antipa on 11/17/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "CMPopTipViewStyleOverride.h"

@implementation CMPopTipViewStyleOverride
+(void)setStylesForPopup:(CMPopTipViewStyleOverride *)popup {
    [popup setBackgroundColor:[UIColor blueColor]];
    [popup setTextFont:[UIFont systemFontOfSize:16.0]];
    [popup setTextColor:[UIColor whiteColor]];
}
@end