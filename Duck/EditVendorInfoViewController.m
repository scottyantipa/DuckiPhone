//
//  EditVendorInfoViewController.m
//  Duck
//
//  Created by Scott Antipa on 4/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "EditVendorInfoViewController.h"

@interface EditVendorInfoViewController ()

@end

@implementation EditVendorInfoViewController
@synthesize vendor = _vendor;
@synthesize scrollView = scrollView;
@synthesize activeField = activeField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.textFieldForFirstName.tag = 1;
    self.textFieldForLastName.tag = 2;
    self.textFieldForEmail.tag = 3;
    
    self.textFieldForFirstName.text = _vendor.firstName;
    self.textFieldForLastName.text = _vendor.lastName;
    self.textFieldForEmail.text = _vendor.email;
    
    NSArray * fields = @[self.textFieldForEmail, self.textFieldForFirstName, self.textFieldForLastName];
    for (UITextField * field in fields) {field.returnKeyType = UIReturnKeyDone;}
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.5);
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    int tag = textField.tag;
    [self.view endEditing:YES];
    [self updateFieldForTag:tag];
    return YES;
}
//
-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
    int tag = textField.tag;
    [self updateFieldForTag:tag];
}

-(void)updateFieldForTag:(int)tag {
    switch (tag) {
        case 1:
            _vendor.firstName = self.textFieldForFirstName.text;
            break;
            
        case 2:
            _vendor.lastName = self.textFieldForLastName.text;
            break;
            
        case 3:
            _vendor.email = self.textFieldForEmail.text;
            break;
            
        default:
            break;
    }
}


// got all of this stuff about moving the scroll view from apple at
//https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = activeField.frame.origin;
    origin.y -= scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-(aRect.size.height));
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}



@end
