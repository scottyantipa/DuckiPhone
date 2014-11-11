//
//  BottlesInInvoiceTVC.h
//  Duck
//
//  Created by Scott Antipa on 9/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Invoice+Create.h"
#import "ToggleBottlesDelegate.h"
#import "ToggleBottlesTableViewController.h"
#import "InvoiceForBottle.h"
#import "EditPriceAndQtyVC.h"
#import "Bottle+Create.h"
#import "UIColor+BFPaperColors.h"
#import "BFPaperButton.h"

@interface BottlesInInvoiceTVC : UITableViewController <ToggleBottlesDelegate, EditPriceAndQuantityDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Invoice * invoice;
@property (strong, nonatomic) NSArray * sortedInvoicesByBottle;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (nonatomic, strong) InvoiceForBottle * mostRecentInvoiceForBottleAdded;
@property (nonatomic, strong) NSMutableDictionary * noOrderForBottles;
@end
