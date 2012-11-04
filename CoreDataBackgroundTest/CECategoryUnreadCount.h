//
//  CECategoryUnreadCount.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/5/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"

extern NSString* const kUnreadCount;

@interface Category (UnreadCount)

- (NSNumber*)unreadCount;

@end
