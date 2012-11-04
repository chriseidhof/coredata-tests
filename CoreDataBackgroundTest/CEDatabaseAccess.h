//
//  CEDatabaseAccess.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CEDatabaseAccess <NSObject>

- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel*)managedObjectModel;

@end

@interface CEDatabaseAccess : NSObject <CEDatabaseAccess>

@end
