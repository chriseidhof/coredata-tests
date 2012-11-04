//
//  CEDetailViewController.h
//  CoreDataBackgroundTest
//
//  Created by Chris Eidhof on 11/4/12.
//  Copyright (c) 2012 Chris Eidhof. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
