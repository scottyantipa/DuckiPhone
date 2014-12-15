//
//  AppDelegate.m
//  Duck02
//
//  Created by Scott Antipa on 8/22/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "AppDelegate.h"
#import "MOCManager.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UITabBarController * mainTabBar = (UITabBarController *)self.window.rootViewController;
    mainTabBar.delegate = self;
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[MOCManager sharedInstance] saveBaseContext];
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // prepare for tab bar changes
}

@end
