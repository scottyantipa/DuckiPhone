//
//  Order.m
//  Duck
//
//  Created by Scott Antipa on 9/28/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "Order.h"
#import "Invoice.h"
#import "OrderForBottle.h"
#import "Vendor.h"


@implementation Order

@dynamic arrived;
@dynamic date;
@dynamic sent;
@dynamic totalAmount;
@dynamic invoices;
@dynamic ordersByBottle;
@dynamic whichVendor;

@end
