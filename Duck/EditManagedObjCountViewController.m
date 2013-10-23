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
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.textFieldForCount.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad {
    // replace text field with the actual count of the bottle
    [self.textFieldForCount resignFirstResponder];
    float count = [self.delegate countOfManagedObject:self.managedObj];
    NSString * text = [NSString stringWithFormat:@"%g", count];
    self.textFieldForCount.text = text;
}

-(void)doneWithNumberPad {
    NSString * text = self.textFieldForCount.text;
    CGFloat floatVal = (CGFloat)[text floatValue];
    [self.textFieldForCount resignFirstResponder];
    [self.delegate didFinishEditingCount:&floatVal forObject:self.managedObj];
}
@end
