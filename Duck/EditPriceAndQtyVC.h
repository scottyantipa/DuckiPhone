//
//  EditOrderForBottleDetailsViewController.h
//  Duck03
//
//  Created by Scott Antipa on 9/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderForBottle+Create.h"
#import "Bottle+Create.h"
#import "EditPriceAndQuantityDelegate.h"

@interface EditPriceAndQtyVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField * textFieldForUnits;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForPrice;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) id managedObject;
@property (weak) id <EditPriceAndQuantityDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel * objectNameLabel;
@end
