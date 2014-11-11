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

const float BUTTON_RADIUS = 40.0;

const float NAME_HEIGHT = 20.0;
const float NAME_FONT_SIZE = 14.0;

const float COUNT_HEIGHT = 30;
const float COUNT_FONT_SIZE = 20.0;


+(void)formatCell:(TakeInventoryTableViewCell *)cell forBottle:(Bottle *)bottle {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (cell.nameLabel == nil) {
        cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 40, NAME_HEIGHT)];
        [cell addSubview:cell.nameLabel];
    }
    cell.nameLabel.text = bottle.name;
    
    if (cell.editCountLabel == nil) {
        cell.editCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAME_HEIGHT, 70, COUNT_HEIGHT)];
        [cell addSubview:cell.editCountLabel];
    }
    
    if (cell.plusButton == nil) {
        cell.plusButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(screenWidth - BUTTON_RADIUS - 20, NAME_HEIGHT + 20, BUTTON_RADIUS, BUTTON_RADIUS) raised:YES];
        [cell.plusButton setTitle:@"+" forState:UIControlStateNormal];
        [self formatButton:cell.plusButton];
        [cell addSubview:cell.plusButton];
    }
    
    if (cell.minusButton == nil) {
        cell.minusButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(screenWidth - (BUTTON_RADIUS * 2) - 40, NAME_HEIGHT + 20, BUTTON_RADIUS, BUTTON_RADIUS) raised:YES];
        [cell.minusButton setTitle:@"-" forState:UIControlStateNormal];
        [self formatButton:cell.minusButton];
        [cell addSubview:cell.minusButton];
    }
}


+(void)formatButton:(BFPaperButton *)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:1 alpha:1];
    button.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    button.cornerRadius = button.frame.size.width / 2;
    button.rippleFromTapLocation = NO;
    button.rippleBeyondBounds = YES;
    button.tapCircleDiameter = MAX(button.frame.size.width, button.frame.size.height) * 1.3;
}


@end
