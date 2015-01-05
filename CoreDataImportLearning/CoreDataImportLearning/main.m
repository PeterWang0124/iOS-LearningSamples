//
//  main.m
//  CoreDataImportLearning
//
//  Created by PeterWang on 12/31/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSDate+MSExcel.h"

//Model
#import "CDLNationalParkInfo.h"
#import "CDLNationalParkDetail.h"

NSManagedObjectContext * managedObjectContext(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //Create managed object context.
        NSManagedObjectContext *context = managedObjectContext();
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        NSLog(@"run success!!");
        
        //Import national parks json datas.
        NSError *err = nil;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"NationalParks" ofType:@"json"];
        NSArray *nationalParks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
        NSLog(@"Imported national parks count : %zd", [nationalParks count]);
        
        [nationalParks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CDLNationalParkInfo *info = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CDLNationalParkInfo class]) inManagedObjectContext:context];
            CDLNationalParkDetail *detail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CDLNationalParkDetail class]) inManagedObjectContext:context];
            
            info.name = [obj valueForKey:@"name"];
            info.type = [obj valueForKey:@"type"];
            info.code = [obj valueForKey:@"code"];
            info.detail = detail;
            
            detail.note = [obj valueForKey:@"note"];
            double time = [[obj objectForKey:@"update_time"] doubleValue];
            detail.updateTime = [NSDate dateWithExcelSerialDateSince1904:time];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM dd, YYYY"];
            NSLog(@"%@, %@, %f", info.name, [formatter stringFromDate:detail.updateTime], time);
            detail.info = info;
        }];
        
        if ([nationalParks count] && ![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        //Test listing all CDLNationalParkInfos from the store
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CDLNationalParkInfo class]) inManagedObjectContext:context];
//        [fetchRequest setEntity:entity];
//        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//        for (CDLNationalParkInfo *info in fetchedObjects) {
//            NSLog(@"Name: %@", info.name);
//            CDLNationalParkDetail *detail = info.detail;
//            NSLog(@"note : %@", detail.note);
//        }
    }
    return 0;
}

#pragma mark - Core Data stack

NSURL * urlApplicationDocumentsDirectory(void) {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.peter.CoreDataImportLearning" in the application's documents directory.
    return [[NSBundle mainBundle] bundleURL];
}

NSString * stringApplicationDocumentsDirectory(void) {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.peter.CoreDataImportLearning" in the application's documents directory.
    return [urlApplicationDocumentsDirectory() path];
}

NSManagedObjectModel * managedObjectModel(void) {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataImportLearning" withExtension:@"momd"];
    NSLog(@"modelURL : %@", modelURL);
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

NSPersistentStoreCoordinator * persistentStoreCoordinator(void) {
    // Create the coordinator and store    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
    NSURL *storeURL = [urlApplicationDocumentsDirectory() URLByAppendingPathComponent:@"CoreDataImportLearning.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

NSManagedObjectContext * managedObjectContext(void) {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    NSPersistentStoreCoordinator *coordinator = persistentStoreCoordinator();
    if (!coordinator) {
        NSLog(@"Create persistent store coordinator error!");
        return nil;
    }
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    return managedObjectContext;
}