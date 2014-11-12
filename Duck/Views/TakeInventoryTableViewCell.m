//
//  TakeInventoryTableViewCell.m
//  Duck
//
//  Created by Scott Antipa on 11/10/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "TakeInventoryTableViewCell.h"

@implementation TakeInventoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

const float BUTTON_RADIUS = 60.0;

const float NAME_HEIGHT = 20.0;
const float NAME_FONT_SIZE = 14.0;

const float BUTTONS_VERT_OFFSET = NAME_HEIGHT + 30;
const float COUNT_HEIGHT = 30;
const float COUNT_WIDTH = 80;
const float COUNT_FONT_SIZE = 35.0;

CGFloat const CELL_HEIGHT = 130;

+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (cell.nameLabel == nil) {
        cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 20, NAME_HEIGHT)];
        [cell.nameLabel setTextAlignment:NSTextAlignmentCenter];
        cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.nameLabel.numberOfLines = 0;
        cell.nameLabel.font = [UIFont systemFontOfSize:13.0];
        cell.nameLabel.textColor = [UIColor grayColor];
        [cell addSubview:cell.nameLabel];
    }
    cell.nameLabel.text = bottle.name;
    
    if (cell.editCountLabel == nil) {
        CGFloat centerOffset = screenWidth / 2 - COUNT_WIDTH - 30;
        cell.editCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerOffset, BUTTONS_VERT_OFFSET + 10, COUNT_WIDTH, COUNT_HEIGHT)];
        cell.editCountLabel.font = [UIFont systemFontOfSize:COUNT_FONT_SIZE];
        cell.editCountLabel.textColor = [UIColor grayColor];
        [cell addSubview:cell.editCountLabel];
    }
    
    if (cell.plusButton == nil) {
        cell.plusButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(screenWidth - BUTTON_RADIUS - 20, BUTTONS_VERT_OFFSET, BUTTON_RADIUS, BUTTON_RADIUS) raised:NO];
        [cell.plusButton setTitle:@"+" forState:UIControlStateNormal];
        [self formatButton:cell.plusButton forPlus:YES];
        [cell addSubview:cell.plusButton];
    }
    
    if (cell.minusButton == nil) {
        cell.minusButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(screenWidth - (BUTTON_RADIUS * 2) - 40, BUTTONS_VERT_OFFSET, BUTTON_RADIUS, BUTTON_RADIUS) raised:YES];
        [cell.minusButton setTitle:@"-" forState:UIControlStateNormal];
        [self formatButton:cell.minusButton forPlus:NO];
        [cell addSubview:cell.minusButton];
    }
}


+(void)formatButton:(BFPaperButton *)button forPlus:(bool)isPlus {
    [button setTitleFont:[UIFont systemFontOfSize:25.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.backgroundColor = isPlus ? [UIColor colorWithRed:0 green:.7 blue:.27 alpha:.5] : [UIColor colorWithRed:.7 green:0 blue:0 alpha:.5];
    button.tapCircleColor = isPlus ? [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6] : [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    button.cornerRadius = button.frame.size.width / 2; // make circular
    button.rippleFromTapLocation = NO;
    button.rippleBeyondBounds = NO;
    button.tapCircleDiameter = button.frame.size.width;
}


@end
