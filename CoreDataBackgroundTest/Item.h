//
//  Item.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/5/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString* kRead;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSManagedObject *category;

@end
