//
//  CECategoryUnreadCount.m
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/5/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import "CECategoryUnreadCount.h"
#import "CEObserveNestedValue.h"
#import "Category.h"
#import "Item.h"

NSString* const kUnreadCount = @"unreadCount";


// We don't import objc runtime because it also declares a class called Category.
extern void objc_setAssociatedObject(id object, const void *key, id value, uintptr_t policy);
extern id objc_getAssociatedObject(id object, const void *key);

@implementation Category (UnreadCount)

- (CEObserveNestedValue*)unreadCountObserver {
    CEObserveNestedValue* observer = objc_getAssociatedObject(self,_cmd);
    if(observer == nil) {
        observer = [[CEObserveNestedValue alloc] initWithObject:self collectionKey:kItems childKey:kRead calculator:^id(Category* category) {
            NSInteger readCount = [[category valueForKeyPath:@"items.@sum.read"] integerValue];
            return @(category.items.count - readCount);
        }];
        objc_setAssociatedObject(self, _cmd, observer, 01401);
    }
    return observer;
}

- (NSNumber*)unreadCount {
    return [self unreadCountObserver].value;
}

+ (NSSet *)keyPathsForValuesAffectingUnreadCount {
    return [NSSet setWithObject:@"unreadCountObserver.value"];
}


@end