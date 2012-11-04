//
//  CEObserveNestedValue.m
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/5/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import "CEObserveNestedValue.h"

@interface CEObserveNestedValue () {
    id object;
    NSString* childKey;
    NSString* collectionKey;
    calculateNewValue calculator;
    id cachedValue;
}

@property (nonatomic,strong) id value;

@end

@implementation CEObserveNestedValue

- (id)initWithObject:(id)object_ collectionKey:(NSString*)collectionKey_ childKey:(NSString*)childKey_ calculator:(calculateNewValue)calculator_ {
    self = [super init];
    if(self) {
        object = object_;
        childKey = childKey_;
        calculator = calculator_;
        collectionKey = collectionKey_;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupObservers];
    [self updateValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:collectionKey]) {
        NSKeyValueChange changeKind = [change[NSKeyValueChangeKindKey] intValue];
        if(changeKind == NSKeyValueChangeInsertion) {
            NSArray* items = [change[NSKeyValueChangeNewKey] allObjects];
            for(id child in items) {
                [child addObserver:self forKeyPath:childKey options:NSKeyValueObservingOptionNew context:nil];
            }
        } else if(changeKind == NSKeyValueChangeRemoval) {
            NSArray* items = [change[NSKeyValueChangeNewKey] allObjects];
            for(id item in items) {
                [item removeObserver:self forKeyPath:childKey];
            }
        }
        [self updateValue];
    } else if([keyPath isEqualToString:childKey]) {
        [self updateValue];
    }
}

- (void)setupObservers {
    [object addObserver:self forKeyPath:collectionKey options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    for(id item in [object valueForKey:collectionKey]) {
        [item addObserver:self forKeyPath:childKey options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObservers {
    [object removeObserver:self forKeyPath:collectionKey];
    for(id item in [object valueForKey:collectionKey]) {
        [item removeObserver:self forKeyPath:childKey];
    }
}

- (void)updateValue {
    [self setValue:calculator(object)];    
}

- (void)dealloc {
    [self removeObservers];
}


@end
