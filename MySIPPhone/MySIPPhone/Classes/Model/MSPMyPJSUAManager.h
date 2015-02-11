//
//  MSPMyPjsuaManager.h
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRANSPORTID_NONE -1

typedef NS_OPTIONS(NSUInteger, MSPMyPjsuaManagerStatus) {
    MSPMyPjsuaManagerStatusNone                 = 0,
    MSPMyPjsuaManagerStatusInitedPjsua          = 1 << 0,
    MSPMyPjsuaManagerStatusInitedTransport      = 1 << 1,
    MSPMyPjsuaManagerStatusStartedPjsua         = 1 << 2,
    
    MSPMyPjsuaManagerStatusRegisterredSipServer = 1 << 3,
};

typedef NS_ENUM(NSInteger, MSPMyPjsuaManagerResult) {
    MSPMyPjsuaManagerResultSuccess              = 0,
    
    //Pjsua Init Error Code.
    MSPMyPjsuaManagerResultCreatePjsuaError,
    MSPMyPjsuaManagerResultInitPjsuaError,
    MSPMyPjsuaManagerResultPjsuaNotInitedError,
    
    //Pjsua Start Error Code.
    MSPMyPjsuaManagerResultStartPjsuaError,
    
    //Transport Error Code.
    MSPMyPjsuaManagerResultCreateTransportError,
    MSPMyPjsuaManagerResultCreateTransportUDPError,
    MSPMyPjsuaManagerResultCreateTransportTCPError,
    
    //Register Sip Server Error Code.
    MSPMyPjsuaManagerResultRegisterSipServerError,
    
    //Make Call Error Code.
    MSPMyPjsuaManagerResultMakeCallError,
};

@interface MSPMyPjsuaManager : NSObject

@property (assign, nonatomic, readonly) MSPMyPjsuaManagerStatus initStatus;

+ (instancetype)sharedManager;

- (void)start;

//Test
- (MSPMyPjsuaManagerResult)initPjsua;
- (MSPMyPjsuaManagerResult)initPjsuaTransport;
- (MSPMyPjsuaManagerResult)startPjsua;

- (MSPMyPjsuaManagerResult)registerSipServer;
- (MSPMyPjsuaManagerResult)makeCall;

@end
