//
//  CDLMainViewController.h
//  CoreDataLearning
//
//  Created by PeterWang on 12/30/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDLMainViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
