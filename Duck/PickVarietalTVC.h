//
//  PickVarietalTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "PickVarietalDelegate.h"
#import "Varietal.h"

@interface PickVarietalTVC : BaseCoreDataTableViewController
@property (weak) id<PickVarietalDelegate> delegate;
@property (strong, nonatomic) Varietal * selectedVarietal;
@end
