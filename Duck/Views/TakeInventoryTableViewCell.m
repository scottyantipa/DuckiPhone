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
    
    if (cell.plusButton == nil) {
        cell.plusButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - BUTTON_HEIGHT - 30, BUTTONS_VERT_OFFSET, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        
        [cell.plusButton setTitle:@"+" forState:UIControlStateNormal];
        [self formatButton:cell.plusButton forPlus:YES];
        [cell addSubview:cell.plusButton];
    }
    
    if (cell.minusButton == nil) {
        cell.minusButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - (BUTTON_HEIGHT * 2) - 50, BUTTONS_VERT_OFFSET, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        [cell.minusButton setTitle:@"-" forState:UIControlStateNormal];
        [self formatButton:cell.minusButton forPlus:NO];
        [cell addSubview:cell.minusButton];
    }
}


+(void)formatButton:(UIButton *)button forPlus:(bool)isPlus {
    UIColor * green = [UIColor colorWithRed:0 green:.7 blue:.3 alpha:1];
    UIColor * red = [UIColor colorWithRed:.7 green:0 blue:.2 alpha:1];
    UIColor * color = isPlus ? green : red;
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = button.frame.size.width / 2;
}


@end
