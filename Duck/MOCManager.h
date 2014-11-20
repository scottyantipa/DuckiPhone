//
//  MOCManager.h
//  Duck
//
//  Created by Scott Antipa on 11/19/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOCManager : NSObject
+(id)sharedInstance;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveBaseContext;
-(void)saveContext:(NSManagedObjectContext *)context;
-(NSManagedObjectContext *)newMOC;
@end
