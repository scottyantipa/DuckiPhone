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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldForFirstName.tag = 1;
    self.textFieldForLastName.tag = 2;
    self.textFieldForEmail.tag = 3;
    
    self.textFieldForFirstName.text = _vendor.firstName;
    self.textFieldForLastName.text = _vendor.lastName;
    self.textFieldForEmail.text = _vendor.email;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    int tag = textField.tag;
    [self updateFieldForTag:tag];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
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

@end
