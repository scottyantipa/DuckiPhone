//
//  EditBottleNameViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/2/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "EditTextViewController.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self updateTextField];
    return YES;
}

-(void)updateTextField {
    [self.delegate didFinishEditingText:self.textFieldForName.text];
}

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"Edit Bottle Name";
    self.textFieldForName.text = [self.delegate textForNameView];
    self.textFieldForName.returnKeyType = UIReturnKeyDone;
    [super viewWillAppear:animated];
}
@end
