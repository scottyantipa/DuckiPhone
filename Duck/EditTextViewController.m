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
    [self updateTextField];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateTextField];
}

-(void)updateTextField {
    NSString * text = self.textFieldForName.text;
    [self.delegate didFinishEditingText:text];
}

-(void)viewWillAppear:(BOOL)animated {
    // This should be the text of the bottle
    self.title = @"Edit Bottle Name";
    self.textFieldForName.text = [self.delegate textForNameView];
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}
@end
