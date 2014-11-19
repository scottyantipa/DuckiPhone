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
#import "Utils.h"

@interface TakeInventoryTableViewCell : UITableViewCell
+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle showName:(BOOL)showName;
+(float)totalCellHeight;
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * editCountLabel;
@property (strong, nonatomic) PlusMinusButtonsView * plusMinusView;
extern CGFloat const CELL_HEIGHT;
@end
