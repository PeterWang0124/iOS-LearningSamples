//
//  SQLNationalParkDatabase.h
//  SQLiteLearning
//
//  Created by PeterWang on 12/27/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SQLNationalParkSqLiteDbName;
extern NSString * const SQLNationalParkSqLiteDbType;
extern NSString * const SQLNationalParkDbTableName;

@class SQLNationalPark;

/**
 *  Database of national park in sqlite.
 */
@interface SQLNationalParkDatabase : NSObject

/**
 *  Singleton instance of database.
 *
 *  @return Singleton instance of database.
 */
+ (instancetype)sharedDatabase;

/**
 *  Load national park info data from database.
 */
- (void)loadNationalParkInfos;

/**
 *  Fetch the national park infos.
 *
 *  @return A array of national park infos.
 */
- (NSArray *)nationalParks;

/**
 *  Fetch the national park detail.
 *
 *  @param uniqueId Unique Id for national park.
 *
 *  @return National park detail.
 */
- (SQLNationalPark *)nationalParkDetailWithId:(NSInteger)uniqueId;

@end
