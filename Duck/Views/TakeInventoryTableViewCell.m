//
//  TakeInventoryTableViewCell.m
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTableViewCell.h"

@implementation TakeInventoryTableViewCell

const float BUTTON_HEIGHT = 40.0;

const float NAME_HEIGHT = 20.0;
const float NAME_FONT_SIZE = 14.0;
const float LABEL_LEFT_ALIGN = 20;

const float BUTTONS_VERT_OFFSET = NAME_HEIGHT + 10;
const float COUNT_HEIGHT = 30;
const float COUNT_WIDTH = 300;
const float COUNT_FONT_SIZE = 25.0;

CGFloat const CELL_HEIGHT = BUTTONS_VERT_OFFSET + BUTTON_HEIGHT + 15;

+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (cell.nameLabel == nil) {
        cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, 10, screenWidth - 20, NAME_HEIGHT)];
        cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.nameLabel.numberOfLines = 0;
        cell.nameLabel.font = [UIFont systemFontOfSize:15.0];
        cell.nameLabel.textColor = [UIColor grayColor];
        [cell addSubview:cell.nameLabel];
    }
    cell.nameLabel.text = bottle.name;
    
    if (cell.editCountLabel == nil) {
        cell.editCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, BUTTONS_VERT_OFFSET + 10, COUNT_WIDTH, COUNT_HEIGHT)];
        cell.editCountLabel.font = [UIFont systemFontOfSize:COUNT_FONT_SIZE];
        cell.editCountLabel.textColor = [UIColor grayColor];
        [cell addSubview:cell.editCountLabel];
    }
    
    if (cell.plusMinusView == nil) {
        CGRect frame = CGRectMake(screenWidth - [PlusMinusButtonsView viewWidth], 0, [PlusMinusButtonsView viewWidth], [PlusMinusButtonsView buttonHeight]);
        cell.plusMinusView = [[PlusMinusButtonsView alloc] initWithFrame:frame];
        [PlusMinusButtonsView setupView:cell.plusMinusView];
        [cell addSubview:cell.plusMinusView];
    }
}
@end