//
//  MOCManager.m
//  Duck
//
//  Created by Scott Antipa on 11/19/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "MOCManager.h"

@implementation MOCManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(id)sharedInstance {
    static MOCManager * sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

-(NSManagedObjectContext *)newMOC {
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return context;
}

-(void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

-(void)saveBaseContext {
    [self saveContext:_managedObjectContext];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Duck" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *appDirPath = [self applicationDocumentsDirectory];
    NSString *storeFileName = @"mainStore.sqlite";
    NSURL *storeUrl = [appDirPath URLByAppendingPathComponent:storeFileName];
    NSError * error = nil;
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


