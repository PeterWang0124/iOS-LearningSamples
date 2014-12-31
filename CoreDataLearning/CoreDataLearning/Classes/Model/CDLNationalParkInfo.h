//
//  CDLNationalParkInfo.h
//  CoreDataLearning
//
//  Created by PeterWang on 12/31/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDLNationalParkDetail;

@interface CDLNationalParkInfo : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) CDLNationalParkDetail *detail;

@end
