//
//  MSPMyPjsuaManager.m
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPMyPjsuaManager.h"
#import <pjlib.h>
#import <pjsua.h>

@interface MSPMyPjsuaManager ()

@property (assign, nonatomic, readwrite) MSPMyPjsuaManagerInitStatus initStatus;

@end

@implementation MSPMyPjsuaManager

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.initStatus = MSPMyPjsuaManagerInitStatusNone;
    }
    
    return self;
}

- (void)dealloc {
    [self releasePjsua];
}

- (void)releasePjsua {
    pjsua_destroy();
    
    self.initStatus = MSPMyPjsuaManagerInitStatusNone;
}

#pragma mark - Register Process Method

- (void)start {
    MSPMyPjsuaManagerResult result = [self initPjsua];
    if (result != MSPMyPJSUAManagerResultSuccess) {
        return;
    }
}

- (MSPMyPjsuaManagerResult)initPjsua {
    if ((self.initStatus & MSPMyPjsuaManagerInitStatusInitedPjsua) ||
        (self.initStatus & MSPMyPjsuaManagerInitStatusStartedPjsua)) {
        NSLog(@"Pjsua is inited or running!!");
        return MSPMyPJSUAManagerResultSuccess;
    }
    
    pj_status_t status;
    
    //Init pjsua.
    status = pjsua_create();
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_create()", status);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultCreatePjsuaError;
    }
    
    pjsua_config cfg;
    pjsua_logging_config log_cfg;
    
    pjsua_config_default(&cfg);
    cfg.cb.on_incoming_call = &on_incoming_call;
    cfg.cb.on_call_media_state = &on_call_media_state;
    cfg.cb.on_call_state = &on_call_state;
    
    pjsua_logging_config_default(&log_cfg);
    log_cfg.console_level = 4;
    
    status = pjsua_init(&cfg, &log_cfg, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_init()", status);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultInitPjsuaError;
    }
    
    self.initStatus |= MSPMyPjsuaManagerInitStatusInitedPjsua;
    return MSPMyPJSUAManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)initPjsuaTransport {
    if (!(self.initStatus & MSPMyPjsuaManagerInitStatusInitedPjsua)) {
        NSLog(@"Error! pjsua not init, please init pjsua before init pjsua transport.");
        return MSPMyPJSUAManagerResultPjsuaNotInitedError;
    }
    
    if (self.initStatus & MSPMyPjsuaManagerInitStatusStartedPjsua) {
        NSLog(@"Pjsua is running!!");
        return MSPMyPJSUAManagerResultSuccess;
    }

    pj_status_t status;
    pjsua_transport_id transport_id = TRANSPORTID_NONE;
    
    //Init transport config structure
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = 5060;
    
    //Add UDP transport.
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, &transport_id);
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_transport_create(PJSIP_TRANSPORT_UDP)", status);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultCreateTransportUDPError;
    }

    //Add TCP transport.
    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &cfg, &transport_id);
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_transport_create(PJSIP_TRANSPORT_TCP)", status);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultCreateTransportTCPError;
    }
    
    if (transport_id == TRANSPORTID_NONE) {
        NSLog(@"Status ID : %d - Error no transport is configured", TRANSPORTID_NONE);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultCreateTransportError;
    }
    
    self.initStatus |= MSPMyPjsuaManagerInitStatusInitedTransport;
    return MSPMyPJSUAManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)startPjsua {
    if (!(self.initStatus & MSPMyPjsuaManagerInitStatusInitedPjsua) ||
        !(self.initStatus & MSPMyPjsuaManagerInitStatusInitedTransport)) {
        NSLog(@"Error! pjsua not init or transport not init, please init them before start pjsua.");
        return MSPMyPJSUAManagerResultPjsuaNotInitedError;
    }
    
    if (self.initStatus & MSPMyPjsuaManagerInitStatusStartedPjsua) {
        NSLog(@"Pjsua is running!!");
        return MSPMyPJSUAManagerResultSuccess;
    }
    
    pj_status_t status;
    
    //Initialization is done, now start pjsua
    status = pjsua_start();
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_start()", status);
        [self releasePjsua];
        return MSPMyPJSUAManagerResultStartPjsuaError;
    }
    
    self.initStatus |= MSPMyPjsuaManagerInitStatusStartedPjsua;
    return MSPMyPJSUAManagerResultSuccess;
}

#pragma mark - PJSUA call back

void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata) {
    
}

void on_call_media_state(pjsua_call_id call_id) {
    
}

void on_call_state(pjsua_call_id call_id, pjsip_event *e) {
    
}

@end
