//
//  ToggleBottlesDelegate.h
//  Duck
//
//  Created by Scott Antipa on 11/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bottle+Create.h"

@protocol ToggleBottlesDelegate <NSObject>

// User selected/unselected a bottle
-(void)didSelectBottle:(Bottle *)bottle;

// Delegate should know if bottle is selected.  For example, if delegate
// is the global add/remove bottle, the selected property is userHasBottle
-(BOOL)bottleIsSelected:(Bottle *)bottle;
@end
