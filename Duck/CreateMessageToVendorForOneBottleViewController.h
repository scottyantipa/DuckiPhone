//
//  InputOrderMessagePropertiesViewController.h
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Bottle+Create.h"

@interface CreateMessageToVendorForOneBottleViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField * textFieldForVendorEmail;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForVendorName;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForPrice;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForQuantity;
@property (strong, nonatomic) Bottle * bottle;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@end
