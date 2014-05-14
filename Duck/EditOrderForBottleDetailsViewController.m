//
//  EditOrderForBottleDetailsViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "EditOrderForBottleDetailsViewController.h"

@interface EditOrderForBottleDetailsViewController ()

@end

@implementation EditOrderForBottleDetailsViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize orderForBottle = _orderForBottle;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateTextField:textField];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateTextField:textField];
}

-(void)updateTextField:(UITextField *)textField {
    NSString * text = textField.text;
    int tag = textField.tag;
    CGFloat floatVal = (CGFloat)[text floatValue];
    NSNumber * number = [NSNumber numberWithFloat:floatVal];
    if (tag == 1) {
        _orderForBottle.unitPrice = number;
    } else if (tag == 2) {

        _orderForBottle.quantity = number;
    }
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [textField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    // This should be the text of the bottle
    self.textFieldForPrice.text = [fmt stringFromNumber:_orderForBottle.unitPrice];
    self.textFieldForUnits.text = [NSString stringWithFormat:@"%@", _orderForBottle.quantity];
    self.textFieldForPrice.tag = 1;
    self.textFieldForUnits.tag = 2;
    self.textFieldForPrice.keyboardType = UIKeyboardTypeDecimalPad;
    self.textFieldForUnits.keyboardType = UIKeyboardTypeNumberPad;
    self.title = _orderForBottle.whichBottle.name;
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

@end
