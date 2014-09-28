//
//  EditVendorInfoViewController.h
//  Duck
//
//  Created by Scott Antipa on 4/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

// Class for editing the contact information of a vendor

#import <UIKit/UIKit.h>
#import "Vendor+Create.h"

@interface EditVendorInfoViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) Vendor * vendor;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *activeField;
@end
