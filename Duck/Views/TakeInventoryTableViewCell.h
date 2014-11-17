//
//  TakeInventoryTableViewCell.h
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bottle+Create.h"
#import "PlusMinusButtonsView.h"

@interface TakeInventoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * editCountLabel;
@property (strong, nonatomic) PlusMinusButtonsView * plusMinusView;
+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle;
extern CGFloat const CELL_HEIGHT;
@end
