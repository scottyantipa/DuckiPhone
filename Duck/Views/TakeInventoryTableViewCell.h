//
//  TakeInventoryTableViewCell.h
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+BFPaperColors.h"
#import "BFPaperButton.h"
#import "Bottle+Create.h"

@interface TakeInventoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * editCountLabel;
@property (strong, nonatomic) BFPaperButton * plusButton;
@property (strong, nonatomic) BFPaperButton * minusButton;
+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle;
+(void)formatButton:(BFPaperButton *)button;
extern CGFloat const CELL_HEIGHT;
@end
