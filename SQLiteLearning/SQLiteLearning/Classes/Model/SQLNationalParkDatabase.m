//
//  SQLNationalParkDatabase.m
//  SQLiteLearning
//
//  Created by PeterWang on 12/27/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "SQLNationalParkDatabase.h"
#import <sqlite3.h>
#import "SQLNationalPark.h"

NSString * const SQLNationalParkSqLiteDbName = @"nps_boundary_csv";
NSString * const SQLNationalParkSqLiteDbType = @"sqlite3";
NSString * const SQLNationalParkDbTableName = @"nps_boundary";

@interface SQLNationalParkDatabase () {
    sqlite3 *database;
}

@property (strong, nonatomic) MutableOrderedDictionary *nationalParksDictionary;

@end

@implementation SQLNationalParkDatabase

+ (instancetype)sharedDatabase {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //Init database.
        NSString *sqLiteDbPath = [[NSBundle mainBundle] pathForResource:SQLNationalParkSqLiteDbName ofType:SQLNationalParkSqLiteDbType];
        if (sqlite3_open([sqLiteDbPath UTF8String], &database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    
    return self;
}

- (void)dealloc {
    sqlite3_close(database);
}

- (void)loadNationalParkInfos {
    if (!self.nationalParksDictionary) {
        self.nationalParksDictionary = [[MutableOrderedDictionary alloc] init];
    }
    
    //sqlite command to fetch the infos.
    NSString *query = [NSString stringWithFormat:@"SELECT uid, name, type, code FROM %@ ORDER BY name ASC;", SQLNationalParkDbTableName];
    sqlite3_stmt *statement;
    int errorCode = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    if (errorCode == SQLITE_OK) {
        NSUInteger index = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *typeChars = (char *) sqlite3_column_text(statement, 2);
            char *codeChars = (char *) sqlite3_column_text(statement, 3);
            NSString *name = [NSString stringWithUTF8String:nameChars];
            NSString *type = [NSString stringWithUTF8String:typeChars];
            NSString *code = [NSString stringWithUTF8String:codeChars];
            
            NSString *key = [NSString stringWithFormat:@"%d", uniqueId];
            SQLNationalPark *park = self.nationalParksDictionary[key];
            if (!park) {
                park = [[SQLNationalPark alloc] init];
                park.uniqueId = uniqueId;
                [self.nationalParksDictionary insertObject:park forKey:key atIndex:index];
            }
            
            //Update info
            park.name = name;
            park.type = type;
            park.code = code;
            
            ++index;
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Error code : %d", errorCode);
    }
}

- (SQLNationalPark *)nationalParkDetailWithId:(NSInteger)uniqueId {
    SQLNationalPark *park = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT uid, name, type, code, note, update_time FROM %@ WHERE uid=%zd;", SQLNationalParkDbTableName, uniqueId];
    NSLog(@"%@", query);
    sqlite3_stmt *statement;
    int errorCode = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    if (errorCode == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *typeChars = (char *) sqlite3_column_text(statement, 2);
            char *codeChars = (char *) sqlite3_column_text(statement, 3);
            char *noteChars = (char *) sqlite3_column_text(statement, 4);
            char *updateTimeChars = (char *) sqlite3_column_text(statement, 5);
            NSString *name = [NSString stringWithUTF8String:nameChars];
            NSString *type = [NSString stringWithUTF8String:typeChars];
            NSString *code = [NSString stringWithUTF8String:codeChars];
            NSString *note = [NSString stringWithUTF8String:noteChars];
            NSString *updateTimeString = [NSString stringWithUTF8String:updateTimeChars];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:updateTimeString];
            
            NSString *key = [NSString stringWithFormat:@"%d", uniqueId];
            park = self.nationalParksDictionary[key];
            if (park) {
                //Update info
                park.name = name;
                park.type = type;
                park.code = code;
                park.note = note;
                park.updateTime = date;
            }
            
            break;
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Error code : %d", errorCode);
    }
    
    return park;
}

- (NSArray *)nationalParks {
    return [self.nationalParksDictionary allValues];
}

@end
