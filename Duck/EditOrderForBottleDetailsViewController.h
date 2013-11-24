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

@interface EditOrderForBottleDetailsViewController : UIViewController
@property (strong, nonatomic) OrderForBottle * orderForBottle;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForUnits;
@property (strong, nonatomic) IBOutlet UITextField * textFieldForPrice;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@end
