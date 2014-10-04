//
//  LossesForBottleTVC.h
//  Duck
//
//  Created by Scott Antipa on 10/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bottle+Create.h"
#import "InvoiceForBottle.h"
#import "Invoice+Create.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LossesForBottleTVC : UITableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary * lossInfo;
@property (strong, nonatomic) Bottle * bottle;
@property (strong, nonatomic) NSArray * bottleInvoices;
@property (weak, nonatomic) NSNumber * aggregateLoss;
@property (weak, nonatomic) NSNumber * priceOfOldest;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (strong, nonatomic) UITextView * headerTextView;

@end
