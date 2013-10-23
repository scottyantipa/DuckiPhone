//
//  SubTypeSelectorDelegate.h
//  Duck03
//
//  Created by Scott Antipa on 9/2/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlcoholSubType+Create.h"

@protocol SubTypeSelectorDelegate <NSObject>
-(void)didFinishSelectingSubType:(AlcoholSubType *)subType;
@end
