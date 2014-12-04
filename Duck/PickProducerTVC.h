//
//  PickProducerTVC.h
//  Duck
//
//  Created by Scott Antipa on 12/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "PickProducerTVC.h"
#import "Producer.h"
#import "PickProducerDelegate.h"
#import "Bottle+Create.h"

@interface PickProducerTVC : BaseCoreDataTableViewController <UIAlertViewDelegate>
@property (weak) id<PickProducerDelegate> delegate;
@property (strong, nonatomic) Producer * selectedProducer;
@end
