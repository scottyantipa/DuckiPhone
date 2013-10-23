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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString * text = self.textFieldForName.text;
    NSLog(@"%@", text);
    [self.textFieldForName resignFirstResponder];
    [self.delegate didFinishEditingText:text];
    return NO;
}

-(void)viewWillAppear:(BOOL)animated {
    // This should be the text of the bottle
    self.title = @"Edit Bottle Name";
    self.textFieldForName.text = [self.delegate textForNameView];
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

@end
