//
//  CoreDataBackgroundTestTests.m
//  CoreDataBackgroundTestTests
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import "CoreDataBackgroundTestTests.h"
#import "CEDatabaseAccess.h"
#import "OCMock.h"
#import "Category.h"
#import "Item.h"
#import "CECategoryUnreadCount.h"

@interface CoreDataBackgroundTestTests () {
    CEDatabaseAccess* databaseAccess;
}

@end

@implementation CoreDataBackgroundTestTests

- (void)setUp
{
    [super setUp];
    id databaseMock = [OCMockObject partialMockForObject:[[CEDatabaseAccess alloc] init]];
    [[[databaseMock stub] andCall:@selector(fakePersistentStoreCoordinator)
                           onObject:self] persistentStoreCoordinator];
    databaseAccess = databaseMock;
    // Set-up code here.
}

- (NSPersistentStoreCoordinator*)fakePersistentStoreCoordinator {
//    NSLog(@"test");
    static NSPersistentStoreCoordinator* _fakePersistentStoreCoordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fakePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[databaseAccess managedObjectModel]];
        
        [_fakePersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    });
    
    return _fakePersistentStoreCoordinator;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testHasManagedObjectModel {
    STAssertNotNil([databaseAccess managedObjectModel], @"Database should have managed object model");
}

- (void)testDatabaseIsEmpty
{
    NSManagedObjectModel* model = [databaseAccess managedObjectModel];
    for(NSEntityDescription* entityDescription in model.entities) {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entityDescription;
        NSInteger numberOfObjects = [databaseAccess.managedObjectContext executeFetchRequest:fetchRequest error:nil].count;
        STAssertEquals(0, numberOfObjects, @"Expecting zero objects");
    }
}

- (NSInteger)numberOfEvents {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSInteger numberOfObjects = [databaseAccess.managedObjectContext executeFetchRequest:fetchRequest error:nil].count;
    return numberOfObjects;
}

- (void)testAddToDatabase {
    [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:databaseAccess.managedObjectContext];
    [databaseAccess saveContext];
    NSInteger eventCount = [self numberOfEvents];
    STAssertEquals(1, eventCount, @"Expecting one Event");
}

- (void)testObjectInBackgroundContextIsNotSavedToMainContext {
    NSInteger numberOfEventsBefore = [self numberOfEvents];
    __block NSManagedObjectContext* backgroundContext;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundContext.parentContext = databaseAccess.managedObjectContext;
    });
    [backgroundContext performBlockAndWait:^{
        [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:backgroundContext];
//        [context save:nil];
    }];
    NSInteger numberOfEventsAfter = [self numberOfEvents];
    STAssertEquals(numberOfEventsBefore, numberOfEventsAfter, @"Should not have added an Event");
}

- (void)testObjectInBackgroundContextIsSavedToMainContext {
    NSInteger numberOfEventsBefore = [self numberOfEvents];
    __block NSManagedObjectContext* backgroundContext;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundContext.parentContext = databaseAccess.managedObjectContext;
    });
    [backgroundContext performBlockAndWait:^{
        [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:backgroundContext];
        [backgroundContext save:nil];
    }];
    NSInteger numberOfEventsAfter = [self numberOfEvents];
    STAssertEquals(numberOfEventsBefore+1, numberOfEventsAfter, @"Should have added 1 Event");
}

- (Category*)addCategoryWith5Items {
    Category* category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:databaseAccess.managedObjectContext];
    for(NSInteger i = 0; i < 5; i++) {
        Item* item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:databaseAccess.managedObjectContext];
        item.category = category;
        item.title = [NSString stringWithFormat:@"item %d", i];
        item.read = @NO;
    }
    return category;
}

- (void)testRemoveItemFromCategory {
    Category* category = [self addCategoryWith5Items];
    STAssertTrue(5 == category.unreadCount.intValue, @"Category should have 5 unread items");
    Item* item = [category.items anyObject];
    item.category = nil;
    STAssertTrue(4 == category.unreadCount.intValue, @"Category should have 4 unread items");
}

- (void)testItemsAddedToCategory {
    Category* category = [self addCategoryWith5Items];
    STAssertTrue(5 == [category.items count], @"Category should have 5 items");
}

- (void)testUnreadCount {
    Category* category = [self addCategoryWith5Items];
    STAssertTrue(5 == category.unreadCount.intValue, @"Category should have 5 unread items");
    Item* item = [category.items anyObject];
    item.read = @YES;
    STAssertTrue(4 == category.unreadCount.intValue, @"Category should have 4 unread items");
}

- (void)testObservingReadCount {
    Category* category = [self addCategoryWith5Items];
    OCMockObject* observerMock = [OCMockObject mockForClass:[NSObject class]];
    BOOL returnVal = NO;
    [[[observerMock stub] andReturnValue:OCMOCK_VALUE(returnVal)] isKindOfClass:[OCMArg any]];

    [category addObserver:(id)observerMock forKeyPath:kUnreadCount options:0 context:NULL];

    [[observerMock expect] observeValueForKeyPath:kUnreadCount ofObject:category change:OCMOCK_ANY context:nil];

    Item* item = [category.items anyObject];
    item.read = @YES;
    [observerMock verify];
    
    STAssertTrue(4 == category.unreadCount.intValue, @"Category should have 4 unread items");
}


@end
