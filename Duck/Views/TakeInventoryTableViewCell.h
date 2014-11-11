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

@interface TakeInventoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *editCountLabel;
@property (strong, nonatomic) BFPaperButton * plusButton;
@property (strong, nonatomic) BFPaperButton * minusButton;
@end
