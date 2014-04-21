//
//  EditBottleNameViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/2/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTextViewDelegate.h"

@interface EditTextViewController : UIViewController <UITextFieldDelegate>
@property (weak) id <EditTextViewDelegate> delegate;
@property (strong, nonatomic) UITextView * view;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForName;
@end
