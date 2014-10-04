//
//  LossesForBottleTVC.m
//  Duck
//
//  Created by Scott Antipa on 10/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//


// Given info on a set of losses the user has undergone for a bottle
// This will render a table of all of the offending invoices
// and allow them to email the vendor for a refund

#import "LossesForBottleTVC.h"

@interface LossesForBottleTVC ()

@end

@implementation LossesForBottleTVC
@synthesize lossInfo = _lossInfo;
@synthesize bottle = _bottle;
@synthesize bottleInvoices = _bottleInvoices;
@synthesize aggregateLoss = _aggregateLoss;
@synthesize priceOfOldest = _priceOfOldest;
@synthesize numberFormatter = _numberFormatter;
@synthesize headerTextView = _headerTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _bottle = [_lossInfo objectForKey:@"bottle"];
    _bottleInvoices = [_lossInfo objectForKey:@"bottleInvoices"];
    _aggregateLoss = [_lossInfo objectForKey:@"aggregateLoss"];
    _priceOfOldest = [_lossInfo objectForKey:@"priceOfOldest"];
    
    [self setHeader];

}

// create button as header of table to "Add More Bottles"
-(void)setHeader {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int headerHeight = 100;
    
    _headerTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, headerHeight)];
    self.tableView.tableHeaderView = _headerTextView;
    NSString * formattedLoss = [_numberFormatter stringFromNumber:_aggregateLoss];
    _headerTextView.text = [NSString stringWithFormat:@"%@ has lost you %@.  The individual orders are below.", _bottle.name, formattedLoss];
    
    UIButton * emailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailButton.frame = CGRectMake(0, 50, screenWidth, 35);
    [emailButton setTitle:@"Get Vendor Refund" forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [_headerTextView addSubview:emailButton];
}

-(void)sendEmail {
    MFMailComposeViewController * mailTVC = [Invoice mailComposeForBottleRefund:_bottle fromOriginalPrice:_priceOfOldest withBottleInvoices:_bottleInvoices forLossOf:_aggregateLoss];
    mailTVC.mailComposeDelegate = self;
    [self presentViewController:mailTVC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bottleInvoices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"Losses For Bottle Cell ID"];
    InvoiceForBottle * bottleInvoice = [_bottleInvoices objectAtIndex:indexPath.row];
    cell.textLabel.text = [_numberFormatter stringFromNumber:bottleInvoice.unitPrice];
    return cell;
}

#pragma delegate methods

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultFailed) {
        UIAlertView * failedMailAlertView = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"We are not sure what caused the failure" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [failedMailAlertView show];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
