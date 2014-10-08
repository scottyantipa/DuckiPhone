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
@synthesize textFieldForPrice = _textFieldForPrice;
@synthesize textFieldForUnits = _textFieldForUnits;
@synthesize objectNameLabel = _objectNameLabel;


-(void)viewWillAppear:(BOOL)animated {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    // This should be the text of the bottle
    self.textFieldForPrice.text = [NSString stringWithFormat:@"%@",[self.delegate priceOfObj:_managedObject]];
    self.textFieldForUnits.text = [NSString stringWithFormat:@"%@",[self.delegate quantityOfObj:_managedObject]];
    self.textFieldForPrice.keyboardType = UIKeyboardTypeDecimalPad;
    self.textFieldForUnits.keyboardType = UIKeyboardTypeNumberPad;
    _objectNameLabel.text = [self.delegate nameOfObject:_managedObject];
    [self.view setNeedsDisplay];
    [super viewWillAppear:animated];
}

- (IBAction)pressedDone:(id)sender {
    CGFloat priceFloat = (CGFloat)[[_textFieldForPrice text] floatValue];
    CGFloat unitsFloat = (CGFloat)[[_textFieldForUnits text] floatValue];
    NSNumber * price = [NSNumber numberWithFloat:priceFloat];
    NSNumber * quantity = [NSNumber numberWithFloat:unitsFloat];
    
    [self.delegate didFinishEditingPrice:price andQuantity:quantity forObject:_managedObject];
    
}
@end
