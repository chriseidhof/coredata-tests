//
//  CEMasterViewController.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEDetailViewController;

#import <CoreData/CoreData.h>

@interface CEMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CEDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
