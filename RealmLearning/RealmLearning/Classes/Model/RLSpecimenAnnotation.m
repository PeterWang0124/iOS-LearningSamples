//
//  RLSpecimenAnnotation.m
//  RealmLearning
//
//  Created by PeterWang on 1/6/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLSpecimenAnnotation.h"

//Model
#import "RLSpecimen.h"
#import "RLCategory.h"

@implementation RLSpecimenAnnotation

- (instancetype)initWithSpecimen:(RLSpecimen *)specimen {
    self = [super init];
    if (self) {
        _coordinate.latitude = specimen.latitude;
        _coordinate.longitude = specimen.longitude;
        _title = specimen.name;
        _subtitle = specimen.category ? specimen.category.name : @"Uncategorized";
        _specimen = specimen;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;

    [[RLMRealm defaultRealm] beginWriteTransaction];
    _specimen.latitude = newCoordinate.latitude;
    _specimen.longitude = newCoordinate.longitude;
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
