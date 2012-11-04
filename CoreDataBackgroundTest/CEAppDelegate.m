//
//  CEAppDelegate.m
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import "CEAppDelegate.h"
#import "CEMasterViewController.h"
#import "CEDatabaseAccess.h"

@interface CEAppDelegate () {
    CEDatabaseAccess* databaseAccess;
}

@end

@implementation CEAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    databaseAccess = [[CEDatabaseAccess alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    CEMasterViewController *masterViewController = [[CEMasterViewController alloc] initWithNibName:@"CEMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    masterViewController.managedObjectContext = databaseAccess.managedObjectContext;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [databaseAccess saveContext];
}


@end
