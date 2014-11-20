//
//  AppDelegate.m
//  Duck02
//
//  Created by Scott Antipa on 8/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTableViewController.h"
#import "MOCManager.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    HomeTableViewController *controller = (HomeTableViewController *)navigationController.topViewController;
    controller.managedObjectContext = [[MOCManager sharedInstance] managedObjectContext];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[MOCManager sharedInstance] saveBaseContext];
    
}


@end
