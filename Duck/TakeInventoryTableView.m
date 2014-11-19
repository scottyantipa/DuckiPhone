//
//  TakeInventoryTableView.m
//  Duck
//
//  Created by Scott Antipa on 11/18/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTableView.h"

@implementation TakeInventoryTableView

// I subclass this to try the delaysContentTouches hack so that the internal buttons can be touched without delay
// but I haven't got it working yet
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        for (id view in self.subviews)
        {
            // looking for a UITableViewWrapperView
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
            {
                // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
                if([view isKindOfClass:[UIScrollView class]])
                {
                    // turn OFF delaysContentTouches in the hidden subview
                    UIScrollView *scroll = (UIScrollView *) view;
                    scroll.delaysContentTouches = NO;
                }
                break;
            }
        }
    }
    return self;
}
@end
