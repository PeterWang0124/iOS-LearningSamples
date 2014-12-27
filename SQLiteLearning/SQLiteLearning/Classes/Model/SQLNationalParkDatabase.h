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

/**
 *  Database of national park in sqlite.
 */
@interface SQLNationalParkDatabase : NSObject

/**
 *  Singleton instance of database.
 *
 *  @return Singleton instance of database
 */
+ (instancetype)sharedDatabase;

/**
 *  Fetch the national park infos
 *
 *  @return A array of national park infos.
 */
- (NSArray *)nationalParkInfos;

@end
