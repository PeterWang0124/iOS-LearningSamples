//
//  RLSpecimen.h
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Realm/Realm.h>

@class RLCategory;

@interface RLSpecimen : RLMObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *specimenDescription;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDistance distance;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) RLCategory *category;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLSpecimen>
RLM_ARRAY_TYPE(RLSpecimen)
