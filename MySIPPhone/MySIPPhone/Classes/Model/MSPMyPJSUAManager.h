//
//  MSPMyPJSUAManager.h
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSPMyPJSUAManagerResult) {
    MSPMyPJSUAManagerResultSuccess              = 0,
    MSPMyPJSUAManagerResultCreatePjsuaError     = 1,
    MSPMyPJSUAManagerResultInitPjsuaError       = 2,
};

@interface MSPMyPJSUAManager : NSObject

@property (assign, nonatomic, readonly, getter=isPjsuaInited) BOOL pjsuaInited;

+ (instancetype)sharedManager;

- (void)start;

//Test
- (MSPMyPJSUAManagerResult)initPJSUA;

@end
