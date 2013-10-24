//
//  InputOrderMessagePropertiesViewController.m
//  Duck
//
//  Created by Scott Antipa on 10/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "CreateMessageToVendorForOneBottleViewController.h"

@interface CreateMessageToVendorForOneBottleViewController ()

@end

@implementation CreateMessageToVendorForOneBottleViewController
@synthesize bottle = _bottle;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Order %@", _bottle.name];
    OrderForBottle * mostRecentOrder = [Bottle mostRecentOrderForBottle:_bottle inContext:_managedObjectContext];
    self.textFieldForPrice.text = [NSString stringWithFormat:@"%g", [mostRecentOrder.unitPrice floatValue]];
    self.textFieldForQuantity.text = [NSString stringWithFormat:@"%g", [mostRecentOrder.quantity floatValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(IBAction)didTouchCreateButton:(id)sender
{
    // Create email subject/body and present the message controller
    NSString * vendorName = self.textFieldForVendorName.text;
    NSString * vendorEmail = self.textFieldForVendorEmail.text;

    NSString * greeting = [NSString stringWithFormat:@"Hello %@,", vendorName];
    NSString * theAsk = [NSString stringWithFormat:@"I would like to place an order with you as described below:"];
    NSString * bottle = [NSString stringWithFormat:@"Bottle: %@", _bottle.name];
    NSString * quantity = [NSString stringWithFormat:@"Qty: %@", self.textFieldForQuantity.text];
    NSString * price = [NSString stringWithFormat:@"Unit Price: %@", self.textFieldForPrice.text];
    NSString * signOff = [NSString stringWithFormat:@"Thank you. \n\nPowered by Duck Rows"];
    
    NSString * subject = [NSString stringWithFormat:@"Order for %@", _bottle.name];
    NSString * body = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n%@\n\n%@", greeting, theAsk, bottle, quantity, price, signOff];

    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:subject];
    [mailViewController setMessageBody:body isHTML:NO];
    NSArray * toRecipients = [NSArray arrayWithObject:vendorEmail]; // (NSString *) [feed valueForKey:@"email"]];
    [mailViewController setToRecipients:toRecipients];
    [self presentViewController:mailViewController animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Success sending email");
    } else {
        NSLog(@"Failure sending email");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
