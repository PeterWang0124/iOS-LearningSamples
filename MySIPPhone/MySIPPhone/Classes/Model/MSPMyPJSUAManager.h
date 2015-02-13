//
//  MSPMyPjsuaManager.h
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

//Model
#import "MSPPjsuaConfig.h"
#import "MSPPjsuaSipAccount.h"
#import "MSPPjsuaCall.h"

#define TRANSPORTID_NONE -1

typedef NS_OPTIONS(NSUInteger, MSPMyPjsuaManagerStatus) {
    MSPMyPjsuaManagerStatusNone                 = 0,
    MSPMyPjsuaManagerStatusInitedPjsua          = 1 << 0,
    MSPMyPjsuaManagerStatusInitedTransport      = 1 << 1,
    MSPMyPjsuaManagerStatusStartedPjsua         = 1 << 2,
    
    MSPMyPjsuaManagerStatusRegisterredSipServer = 1 << 3,
    
    MSPMyPjsuaManagerStatusCalling              = 1 << 4,
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
    
    //Hang up Call Error Code.
    MSPMyPjsuaManagerResultHangupCallError,
    
    //Answer Call Error Code.
    MSPMyPjsuaManagerResultAnswerCallError,
};

/**
 *  Manager of pjsua.
 */
@interface MSPMyPjsuaManager : NSObject

@property (assign, nonatomic, readonly) MSPMyPjsuaManagerStatus status;
@property (strong, nonatomic, readonly) MSPPjsuaCall *currentCall;
@property (strong, nonatomic) MSPPjsuaCall *currentIncomingCall;

+ (instancetype)sharedManager;

- (void)loginWithConfig:(MSPPjsuaConfig *)pjsuaConfig accountConfig:(MSPPjsuaSipAccount *)accountConfig;
- (void)logout;

//Process for test pjsua
- (MSPMyPjsuaManagerResult)initPjsua:(MSPPjsuaConfig *)pjsuaConfig;
- (MSPMyPjsuaManagerResult)initPjsuaTransport:(MSPPjsuaConfig *)pjsuaConfig;
- (MSPMyPjsuaManagerResult)startPjsua;

- (MSPMyPjsuaManagerResult)registerSipServer:(MSPPjsuaSipAccount *)sipAccount;
- (MSPMyPjsuaManagerResult)makeCall:(MSPPjsuaCall *)call;
- (MSPMyPjsuaManagerResult)hangupCall:(MSPPjsuaCall *)call;
- (MSPMyPjsuaManagerResult)answerCall:(MSPPjsuaCall *)call;

@end

#pragma mark - Notifications

extern NSString * const MSPCallIncomingNotification;
extern NSString * const MSPCallAnswerNotification;
extern NSString * const MSPCallhangupNotification;

