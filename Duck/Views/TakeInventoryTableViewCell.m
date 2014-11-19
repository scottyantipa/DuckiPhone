//
//  TakeInventoryTableViewCell.m
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTableViewCell.h"

@implementation TakeInventoryTableViewCell

const float NAME_HEIGHT = 20.0;
const float FONT_SIZE = 20.0;
const float LABEL_LEFT_ALIGN = 20;

const float BUTTONS_VERT_OFFSET = NAME_HEIGHT + 20;
const float COUNT_HEIGHT = 30;
const float COUNT_WIDTH = 300;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [Utils markSubviewsAsNoDelay:self];
    }
    return self;
}

+(float)totalCellHeight {
    return [PlusMinusButtonsView buttonHeight] + BUTTONS_VERT_OFFSET + 10;
}

+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle showName:(BOOL)showName {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (cell.nameLabel == nil) {
        cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, 10, screenWidth - 20, NAME_HEIGHT)];
        cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.nameLabel.numberOfLines = 0;
        cell.nameLabel.font = [UIFont systemFontOfSize:15.0];
        [cell addSubview:cell.nameLabel];
    }
    cell.nameLabel.text = bottle.name;
    float vertOffset = showName ? BUTTONS_VERT_OFFSET : 27; // if we aren't showing the name, then put the buttons and count higher up
    if (cell.editCountLabel == nil) {
        // the edit count label isn't as tall as the buttons so it needs to have larger vert offset
        cell.editCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, vertOffset + 5, COUNT_WIDTH, COUNT_HEIGHT)];
        cell.editCountLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [cell addSubview:cell.editCountLabel];
    }
    
    if (cell.plusMinusView == nil) {
        // subtract 20 because of the right hand side scroll bar
        CGRect frame = CGRectMake(screenWidth - [PlusMinusButtonsView viewWidth] - 20, vertOffset, [PlusMinusButtonsView viewWidth], [PlusMinusButtonsView buttonHeight]);
        cell.plusMinusView = [[PlusMinusButtonsView alloc] initWithFrame:frame];
        [PlusMinusButtonsView setupView:cell.plusMinusView];
        [cell addSubview:cell.plusMinusView];
    }
}
@end