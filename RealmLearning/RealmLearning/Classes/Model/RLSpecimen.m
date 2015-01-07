//
//  RLSpecimen.m
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLSpecimen.h"

@implementation RLSpecimen

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"Empty";
        self.specimenDescription = @"No description.";
        self.created = [[NSDate alloc] init];
    }
    
    return self;
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
