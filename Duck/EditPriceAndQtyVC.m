//
//  EditOrderForBottleDetailsViewController.m
//  Duck03
//
//  Created by Scott Antipa on 9/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

//
// A helper class for editing the price and quantity of an object

#import "EditPriceAndQtyVC.h"

@interface EditPriceAndQtyVC ()

@end

@implementation EditPriceAndQtyVC

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObject = _managedObject;

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
        [self.delegate didFinishEditingPrice:number forObject:_managedObject];
    } else if (tag == 2) {
        [self.delegate didFinishEditingQuantity:number forObject:_managedObject];
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
    self.textFieldForPrice.text = [NSString stringWithFormat:@"%@",[self.delegate priceOfObj:_managedObject]];
    self.textFieldForUnits.text = [NSString stringWithFormat:@"%@",[self.delegate quantityOfObj:_managedObject]];
    self.textFieldForPrice.tag = 1;
    self.textFieldForUnits.tag = 2;
    self.textFieldForPrice.keyboardType = UIKeyboardTypeDecimalPad;
    self.textFieldForUnits.keyboardType = UIKeyboardTypeNumberPad;
    self.title = [self.delegate nameOfObject:_managedObject];
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

@end
