//
//  CEObserveNestedValue.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/5/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^calculateNewValue)(id object);

@interface CEObserveNestedValue : NSObject

- (id)initWithObject:(id)object collectionKey:(NSString*)collectionKey childKey:(NSString*)childKey calculator:(calculateNewValue)calculator;
- (id)value;

@end
