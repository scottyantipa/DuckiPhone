//
//  EditBottleCountViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/3/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCountDelegate.h"

@interface EditManagedObjCountViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField * textFieldForCount;
@property (strong, nonatomic) id managedObj;
@property (weak) id <EditCountDelegate> delegate;
@end
