//
//  WineBottleDetailTVC.h
//  Duck
//
//  Created by Scott Antipa on 11/30/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BottleDetailTableViewController.h"
#import "WineBottle+Create.h"
#import "PickVarietalDelegate.h"
#import "PickVarietalTVC.h" 
#import "Producer.h"
#import "PickProducerTVC.h"
#import "PickProducerDelegate.h"

@interface WineBottleDetailTVC : BottleDetailTableViewController <PickVarietalDelegate, PickProducerDelegate>
@property (strong, nonatomic) NSManagedObjectID * varietalForNewBottleID; // if this is a new wine bottle, we can pass a Varietal to start off with
@end
