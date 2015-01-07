//
//  RLSpecimenAnnotation.h
//  RealmLearning
//
//  Created by PeterWang on 1/6/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RLSpecimen;

@interface RLSpecimenAnnotation : NSObject <MKAnnotation>

@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic) RLSpecimen *specimen;

- (instancetype)initWithSpecimen:(RLSpecimen *)specimen;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
