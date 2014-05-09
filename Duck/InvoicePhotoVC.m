//
//  InvoicePhotoVC.m
//  Duck
//
//  Created by Scott Antipa on 5/9/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "InvoicePhotoVC.h"

@interface InvoicePhotoVC ()

@end

@implementation InvoicePhotoVC
@synthesize invoiceImage = _invoiceImage;

-(void)setInvoiceImage:(UIImage *)invoiceImage {
    _invoiceImage = invoiceImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_invoiceImageView setImage:_invoiceImage];
}

@end
