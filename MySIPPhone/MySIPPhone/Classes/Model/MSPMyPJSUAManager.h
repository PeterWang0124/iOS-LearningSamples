//
//  MSPMyPjsuaManager.h
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRANSPORTID_NONE -1

typedef NS_OPTIONS(NSUInteger, MSPMyPjsuaManagerInitStatus) {
    MSPMyPjsuaManagerInitStatusNone             = 0,
    MSPMyPjsuaManagerInitStatusInitedPjsua      = 1 << 0,
    MSPMyPjsuaManagerInitStatusInitedTransport  = 1 << 1,
    MSPMyPjsuaManagerInitStatusStartedPjsua     = 1 << 2,
};

typedef NS_ENUM(NSInteger, MSPMyPjsuaManagerResult) {
    MSPMyPJSUAManagerResultSuccess              = 0,
    
    //Pjsua Init Error Code.
    MSPMyPJSUAManagerResultCreatePjsuaError,
    MSPMyPJSUAManagerResultInitPjsuaError,
    MSPMyPJSUAManagerResultPjsuaNotInitedError,
    
    //Pjsua Start Error Code.
    MSPMyPJSUAManagerResultStartPjsuaError,
    
    //Transport Error Code.
    MSPMyPJSUAManagerResultCreateTransportError,
    MSPMyPJSUAManagerResultCreateTransportUDPError,
    MSPMyPJSUAManagerResultCreateTransportTCPError,
};

@interface MSPMyPjsuaManager : NSObject

@property (assign, nonatomic, readonly) MSPMyPjsuaManagerInitStatus initStatus;

+ (instancetype)sharedManager;

- (void)start;

//Test
- (MSPMyPjsuaManagerResult)initPjsua;
- (MSPMyPjsuaManagerResult)initPjsuaTransport;
- (MSPMyPjsuaManagerResult)startPjsua;

@end
