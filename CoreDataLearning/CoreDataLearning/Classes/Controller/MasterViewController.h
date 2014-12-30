//
//  MasterViewController.h
//  CoreDataLearning
//
//  Created by PeterWang on 12/30/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

