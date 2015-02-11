//
//  MSPMyPJSUAManager.m
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPMyPJSUAManager.h"
#import <pjlib.h>
#import <pjsua.h>

@interface MSPMyPJSUAManager ()

@property (assign, nonatomic, readwrite) BOOL pjsuaInited;

@end

@implementation MSPMyPJSUAManager

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
    }
    
    return self;
}

#pragma mark - Register Process Method

- (void)start {
    MSPMyPJSUAManagerResult result = [self initPJSUA];
    if (result != MSPMyPJSUAManagerResultSuccess) {
        return;
    }
    
    
}

- (MSPMyPJSUAManagerResult)initPJSUA {
    if (self.isPjsuaInited) {
        return MSPMyPJSUAManagerResultSuccess;
    }
    
    pj_status_t status;
    
    //Init pjsua.
    status = pjsua_create();
    if (status != PJ_SUCCESS) {
        NSLog(@"Status ID : %d - Error in pjsua_create()", status);
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
        pjsua_destroy();
        return MSPMyPJSUAManagerResultInitPjsuaError;
    }
    
    self.pjsuaInited = YES;
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
