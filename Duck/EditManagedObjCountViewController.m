//
//  EditBottleCountViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/3/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "EditManagedObjCountViewController.h"

@interface EditManagedObjCountViewController ()

@end

@implementation EditManagedObjCountViewController
@synthesize managedObj = _managedObj;

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"Edit Bottle Count";
    float count = [self.delegate countOfManagedObject:self.managedObj];
    NSString * text = [NSString stringWithFormat:@"%g", count];
    self.textFieldForCount.text = text;
    self.textFieldForCount.keyboardType = UIKeyboardTypeNumberPad;
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateTextField];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateTextField];
}

-(void)updateTextField {
    NSString * text = self.textFieldForCount.text;
    CGFloat floatVal = (CGFloat)[text floatValue];
    NSNumber * num = [NSNumber numberWithFloat:floatVal];
    [self.delegate didFinishEditingCount:num forObject:self.managedObj];;
}

@end
