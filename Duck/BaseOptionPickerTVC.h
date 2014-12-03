//
//  BaseOptionPickerTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePickerDelegate.h"

@interface BaseOptionPickerTVC : UITableViewController
@property (strong, nonatomic) NSArray * data;
@property (strong, nonatomic) NSString * selectedValue;
@property (weak) id<BasePickerDelegate> delegate;
@end
