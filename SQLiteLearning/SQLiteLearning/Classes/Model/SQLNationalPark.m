//
//  SQLNationalPark.m
//  SQLiteLearning
//
//  Created by PeterWang on 12/27/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "SQLNationalPark.h"

@implementation SQLNationalPark

- (instancetype)initWithUniqueId:(NSInteger)uniqueId name:(NSString *)name type:(NSString *)type code:(NSString *)code note:(NSString *)note updateTime:(NSDate *)updateTime {
    self = [super init];
    if (self) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.type = type;
        self.code = code;
        self.note = note;
        self.updateTime = updateTime;
    }
    
    return self;
}

@end
