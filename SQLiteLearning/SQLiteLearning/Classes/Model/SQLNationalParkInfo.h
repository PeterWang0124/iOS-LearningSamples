//
//  SQLNationalParkInfo.h
//  SQLiteLearning
//
//  Created by PeterWang on 12/27/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  National Park Info Model.
 */
@interface SQLNationalParkInfo : NSObject

@property (assign, nonatomic) NSInteger uniqueId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *note;
@property (strong, nonatomic) NSDate *updateTime;

/**
 *  init the National Park Info data.
 *
 *  @param uniqueId   Unique id of the info data.
 *  @param name       Name of park.
 *  @param type       Type of park.
 *  @param code       Code of park.
 *  @param note       Note of park.
 *  @param updateTime Data update time of park.
 *
 *  @return National park info which is init from parameters.
 */
- (instancetype)initWithUniqueId:(NSInteger)uniqueId name:(NSString *)name type:(NSString *)type code:(NSString *)code note:(NSString *)note updateTime:(NSDate *)updateTime;

@end
