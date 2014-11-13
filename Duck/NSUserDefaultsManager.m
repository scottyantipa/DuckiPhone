//
//  NSUserDefaultsManager.m
//  Duck
//
//  Created by Scott Antipa on 11/12/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "NSUserDefaultsManager.h"

@implementation NSUserDefaultsManager
+(BOOL)isFirstTimeShowingClass:(NSString *)classString {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:classString]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:classString];
        return YES;
    }
}
@end

