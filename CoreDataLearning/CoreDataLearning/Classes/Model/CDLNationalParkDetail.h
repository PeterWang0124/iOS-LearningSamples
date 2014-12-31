//
//  CDLNationalParkDetail.h
//  CoreDataLearning
//
//  Created by PeterWang on 12/31/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDLNationalParkInfo;

@interface CDLNationalParkDetail : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) CDLNationalParkInfo *info;

@end
