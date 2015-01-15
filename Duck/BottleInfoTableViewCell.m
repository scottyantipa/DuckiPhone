//
//  BottleInfoTableViewCell.m
//  Duck
//
//  Created by Scott Antipa on 1/14/15.
//  Copyright (c) 2015 Scott Antipa. All rights reserved.
//

#import "BottleInfoTableViewCell.h"

@implementation BottleInfoTableViewCell

const float LABEL_LEFT_ALIGN = 20.0;
const float TOP_BOTTOM_PAD = 15.0;

const float FONT_SIZE = 18.0;
const float SMALL_FONT = 13.0;

const float NAME_LABEL_HEIGHT = FONT_SIZE + 4;
const float DETAIL_LABEL_HEIGHT = SMALL_FONT + 2;

const float DETAIL_LABEL_OFFSET = TOP_BOTTOM_PAD + NAME_LABEL_HEIGHT + 10;


+(void)formatCell:(BottleInfoTableViewCell *)cell forBottle:(Bottle *)bottle {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (cell.nameLabel == nil) {
        cell.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, TOP_BOTTOM_PAD, screenWidth - 20, NAME_LABEL_HEIGHT)];
        cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.nameLabel.numberOfLines = 0;
        cell.nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    }
    cell.nameLabel.text = [bottle fullName];
    
    
    NSString * detailText = [NSString stringWithFormat:@"Produced by %@", bottle.producerName ? bottle.producerName : @"Unknown"];
    if ([bottle.userHasBottle isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSNumber * count = [Bottle countOfBottle:bottle forContext:bottle.managedObjectContext];
        detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@", %@ in stock", count]];
    }
    if (cell.bottleDetailLabel == nil) {
        cell.bottleDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LEFT_ALIGN, DETAIL_LABEL_OFFSET, screenWidth - 20, DETAIL_LABEL_HEIGHT)];
        cell.bottleDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.bottleDetailLabel.numberOfLines = 0;
        cell.bottleDetailLabel.font = [UIFont systemFontOfSize:SMALL_FONT];
        cell.bottleDetailLabel.textColor = [UIColor grayColor];
    }
    cell.bottleDetailLabel.text = detailText;
    
    [cell addSubview:cell.nameLabel];
    [cell addSubview:cell.bottleDetailLabel];
}


+(float)totalCellHeight {
    return DETAIL_LABEL_OFFSET + DETAIL_LABEL_HEIGHT + TOP_BOTTOM_PAD; // this is the vert offset of the label, plus the labels height, plus some padding on bottom
}
@end