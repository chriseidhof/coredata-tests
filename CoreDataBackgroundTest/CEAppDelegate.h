//
//  CEAppDelegate.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
