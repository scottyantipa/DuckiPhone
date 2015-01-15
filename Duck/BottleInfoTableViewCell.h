//
//  BottleInfoTableViewCell.h
//  Duck
//
//  Created by Scott Antipa on 1/14/15.
//  Copyright (c) 2015 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bottle+Create.h"

@interface BottleInfoTableViewCell : UITableViewCell
+(void)formatCell:(BottleInfoTableViewCell *)cell forBottle:(Bottle *)bottle;
+(float)totalCellHeight;

@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * bottleDetailLabel;
@end
