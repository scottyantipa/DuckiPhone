//
//  EditCountDelegate.h
//  Duck03
//
//  Created by Scott Antipa on 9/3/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditCountDelegate <NSObject>
-(void)didFinishEditingCount:(NSNumber *)count forObject:(id)obj;
-(float)countOfManagedObject:(id)obj;
@end
