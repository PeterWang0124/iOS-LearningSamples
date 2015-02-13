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
#import "NSNotificationCenter+MSP.h"

NSString * const MSPCallIncomingNotification = @"com.peter.MSPCallIncomingNotification";
NSString * const MSPCallAnswerNotification = @"com.peter.MSPCallAnswerNotification";
NSString * const MSPCallhangupNotification = @"com.peter.MSPCallhangupNotification";

NSString * const MSPPjsuaQueueName = @"com.peter.MSPPjsuaQueueName";

@interface MSPMyPjsuaManager () {
    pj_pool_t *appPool;
    pj_pool_t *tmpPool;
}

@property (assign, nonatomic, readwrite) MSPMyPjsuaManagerStatus status;
@property (strong, nonatomic) MSPPjsuaSipAccount *currentSipAccount;
@property (strong, nonatomic, readwrite) MSPPjsuaCall *currentCall;

@property (strong, nonatomic) NSMutableDictionary *calls;
@property (strong, nonatomic) dispatch_queue_t pjsuaQueue;

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
        self.status = MSPMyPjsuaManagerStatusNone;
        self.calls = [[NSMutableDictionary alloc] init];
        
        //Create queue for pjsua to run.
        //self.pjsuaQueue = dispatch_queue_create([MSPPjsuaQueueName UTF8String], NULL);
    }
    
    return self;
}

- (void)dealloc {
    [self releasePjsua];
}

- (void)releasePjsua {
    pjsua_call_hangup_all();
    if (appPool) {
        pj_pool_release(appPool);
        appPool = nil;
    }
    if (tmpPool) {
        pj_pool_release(tmpPool);
        tmpPool = nil;
    }
    pjsua_destroy();
    
    self.status = MSPMyPjsuaManagerStatusNone;
    self.currentSipAccount = nil;
    [self.calls removeAllObjects];
}

#pragma mark - Easy connect APIs

- (void)loginWithConfig:(MSPPjsuaConfig *)pjsuaConfig accountConfig:(MSPPjsuaSipAccount *)accountConfig {
    if ((self.status & MSPMyPjsuaManagerStatusInitedPjsua) ||
        (self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        //If pjsua has been init or running, release it and create new one;
        [self releasePjsua];
    }
    
    MSPMyPjsuaManagerResult result = MSPMyPjsuaManagerResultSuccess;
    
    result = [self initPjsua:pjsuaConfig];
    if (result != MSPMyPjsuaManagerResultSuccess) {
        return;
    }
    
    result = [self initPjsuaTransport:pjsuaConfig];
    if (result != MSPMyPjsuaManagerResultSuccess) {
        return;
    }

    result = [self startPjsua];
    if (result != MSPMyPjsuaManagerResultSuccess) {
        return;
    }
    
    result = [self registerSipServer:accountConfig];
}

- (void)logout {
    [self releasePjsua];
}

#pragma mark - PJSUA Process Method

- (MSPMyPjsuaManagerResult)initPjsua:(MSPPjsuaConfig *)pjsuaConfig {
    if ((self.status & MSPMyPjsuaManagerStatusInitedPjsua) ||
        (self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        NSLog(@"\n\nPjsua is inited or running!!\n\n");
        return MSPMyPjsuaManagerResultSuccess;
    }
    
    pj_status_t status;
    
    //Create pjsua.
    status = pjsua_create();
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_create()\n\n", status);
        [self releasePjsua];
        return MSPMyPjsuaManagerResultCreatePjsuaError;
    }
    
    //Create pool for application.
//    appPool = pjsua_pool_create("pjsua-app", 1000, 1000);
//    tmpPool = pjsua_pool_create("pjsua-tmp", 1000, 1000);
    
    //Set up configs.
    pjsua_config cfg;
    pjsua_logging_config log_cfg;
    
    //Set to default.
    pjsua_config_default(&cfg);
    
    //Init pjsua callbacks.
    cfg.cb.on_call_state                    = &on_call_state;
    cfg.cb.on_incoming_call                 = &on_incoming_call;
    
    cfg.cb.on_call_media_state              = &on_call_media_state;
//    cfg.cb.on_call_sdp_created              = &on_call_sdp_created;
//    cfg.cb.on_call_tsx_state                = &on_call_tsx_state;
//    
//    cfg.cb.on_stream_created                = &on_stream_created;
//    cfg.cb.on_stream_destroyed              = &on_stream_destroyed;
//    
//    cfg.cb.on_dtmf_digit                    = &on_dtmf_digit;
//    
//    cfg.cb.on_call_transfer_request         = &on_call_transfer_request;
//    cfg.cb.on_call_transfer_request2        = &on_call_transfer_request2;
//    cfg.cb.on_call_transfer_status          = &on_call_transfer_status;
//    
//    cfg.cb.on_call_replace_request          = &on_call_replace_request;
//    cfg.cb.on_call_replace_request2         = &on_call_replace_request2;
//    cfg.cb.on_call_replaced                 = &on_call_replaced;
//    
//    cfg.cb.on_call_rx_offer                 = &on_call_rx_offer;
//    
//    cfg.cb.on_reg_started                   = &on_reg_started;
//    cfg.cb.on_reg_state                     = &on_reg_state;
//    cfg.cb.on_reg_state2                    = &on_reg_state2;
//    
//    cfg.cb.on_incoming_subscribe            = &on_incoming_subscribe;
//    cfg.cb.on_srv_subscribe_state           = &on_srv_subscribe_state;
//    
//    cfg.cb.on_buddy_state                   = &on_buddy_state;
//    cfg.cb.on_buddy_evsub_state             = &on_buddy_evsub_state;
//    
//    cfg.cb.on_pager                         = &on_pager;
//    cfg.cb.on_pager2                        = &on_pager2;
//    cfg.cb.on_pager_status                  = &on_pager_status;
//    cfg.cb.on_pager_status2                 = &on_pager_status2;
//    
//    cfg.cb.on_typing                        = &on_typing;
//    cfg.cb.on_typing2                       = &on_typing2;
//    
//    cfg.cb.on_nat_detect                    = &on_nat_detect;
//    
//    cfg.cb.on_call_redirected               = &on_call_redirected;
//    
//    cfg.cb.on_mwi_state                     = &on_mwi_state;
//    cfg.cb.on_mwi_info                      = &on_mwi_info;
//    
//    cfg.cb.on_transport_state               = &on_transport_state;
//    cfg.cb.on_call_media_transport_state    = &on_call_media_transport_state;
//    cfg.cb.on_ice_transport_error           = &on_ice_transport_error;
//    cfg.cb.on_snd_dev_operation             = &on_snd_dev_operation;
//    
//    cfg.cb.on_call_media_event              = &on_call_media_event;
//    cfg.cb.on_create_media_transport        = &on_create_media_transport;
//    cfg.cb.on_acc_find_for_incoming         = &on_acc_find_for_incoming;
    
    //Set logging config to default.
    pjsua_logging_config_default(&log_cfg);
    log_cfg.console_level = [pjsuaConfig.consoleLevel unsignedIntValue];
    log_cfg.msg_logging = false;
    
    //Init pjsua
    status = pjsua_init(&cfg, &log_cfg, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_init()\n\n", status);
        [self releasePjsua];
        return MSPMyPjsuaManagerResultInitPjsuaError;
    }
    
    self.status |= MSPMyPjsuaManagerStatusInitedPjsua;
    return MSPMyPjsuaManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)initPjsuaTransport:(MSPPjsuaConfig *)pjsuaConfig {
    if (!(self.status & MSPMyPjsuaManagerStatusInitedPjsua)) {
        NSLog(@"\n\nError! pjsua not init, please init pjsua before init pjsua transport.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (self.status & MSPMyPjsuaManagerStatusStartedPjsua) {
        NSLog(@"\n\nPjsua is running!!\n\n");
        return MSPMyPjsuaManagerResultSuccess;
    }

    pj_status_t status;
    pjsua_transport_id transport_id = TRANSPORTID_NONE;
    
    //Init transport config structure
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = [pjsuaConfig.transportProxy unsignedIntValue];
    
    pjsip_transport_type_e transportType;
    if (pjsuaConfig.transportype == MSPTransportTypeUDP) {
        transportType = PJSIP_TRANSPORT_UDP;
    }
    else if (pjsuaConfig.transportype == MSPTransportTypeTCP) {
        transportType = PJSIP_TRANSPORT_TCP;
    }
    
    //Add transport.
    status = pjsua_transport_create(transportType, &cfg, &transport_id);
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_transport_create(%d)\n\n", status, transportType);
        [self releasePjsua];
        if (pjsuaConfig.transportype == MSPTransportTypeUDP) {
            return MSPMyPjsuaManagerResultCreateTransportUDPError;
        }
        else if (pjsuaConfig.transportype == MSPTransportTypeTCP) {
            return MSPMyPjsuaManagerResultCreateTransportTCPError;
        }
        else {
            return MSPMyPjsuaManagerResultCreateTransportError;
        }
    }
    
    if (transport_id == TRANSPORTID_NONE) {
        NSLog(@"\n\nStatus ID : %d - Error no transport is configured\n\n", TRANSPORTID_NONE);
        [self releasePjsua];
        return MSPMyPjsuaManagerResultCreateTransportError;
    }
    
    self.status |= MSPMyPjsuaManagerStatusInitedTransport;
    return MSPMyPjsuaManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)startPjsua {
    if (!(self.status & MSPMyPjsuaManagerStatusInitedPjsua) ||
        !(self.status & MSPMyPjsuaManagerStatusInitedTransport)) {
        NSLog(@"\n\nError! pjsua not init or transport not init, please init them before start pjsua.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (self.status & MSPMyPjsuaManagerStatusStartedPjsua) {
        NSLog(@"\n\nPjsua is running!!\n\n");
        return MSPMyPjsuaManagerResultSuccess;
    }
    
    pj_status_t status;
    
    //Initialization is done, now start pjsua
    status = pjsua_start();
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_start()\n\n", status);
        [self releasePjsua];
        return MSPMyPjsuaManagerResultStartPjsuaError;
    }
    
    self.status |= MSPMyPjsuaManagerStatusStartedPjsua;
    return MSPMyPjsuaManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)registerSipServer:(MSPPjsuaSipAccount *)sipAccount {
    if (!(self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        NSLog(@"\n\nError! pjsua not init, transport not init or not start, please init them before register sip server.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (self.currentSipAccount) {
        pjsua_acc_del([self.currentSipAccount.accountId intValue]);
        self.currentSipAccount = nil;
        self.status &= ~MSPMyPjsuaManagerStatusRegisterredSipServer;
    }
    
    pj_status_t status;
    pjsua_acc_config cfg;
    pjsua_acc_id pjsuaAccountId;
    
    pjsua_acc_config_default(&cfg);
    cfg.id = pj_str((char *)[[NSString stringWithFormat:@"sip:%@@%@", sipAccount.userName, sipAccount.domain] UTF8String]);
    cfg.reg_uri = pj_str((char *)[[NSString stringWithFormat:@"sip:%@", sipAccount.domain] UTF8String]);
    cfg.cred_count = 1;
    cfg.cred_info[0].realm = pj_str((char *)[sipAccount.realm UTF8String]);
    cfg.cred_info[0].scheme = pj_str((char *)[sipAccount.scheme UTF8String]);
    cfg.cred_info[0].username = pj_str((char *)[sipAccount.userName UTF8String]);
    cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
    cfg.cred_info[0].data = pj_str((char *)[sipAccount.password UTF8String]);
    
//    NSLog(@"\n\n----------------- cred_info -----------------");
//    NSLog(@"id : %s", cfg.id.ptr);
//    NSLog(@"reg_uri : %s", cfg.reg_uri.ptr);
//    NSLog(@"cred_count : %d", cfg.cred_count);
//    NSLog(@"cred_info[0].realm : %s", cfg.cred_info[0].realm.ptr);
//    NSLog(@"cred_info[0].scheme : %s", cfg.cred_info[0].scheme.ptr);
//    NSLog(@"cred_info[0].username : %s", cfg.cred_info[0].username.ptr);
//    NSLog(@"cred_info[0].data_type : %d", cfg.cred_info[0].data_type);
//    NSLog(@"cred_info[0].data : %s", cfg.cred_info[0].data.ptr);
//    NSLog(@"----------------- cred_info end -----------------\n\n");
    
    status = pjsua_acc_add(&cfg, PJ_TRUE, &pjsuaAccountId);
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_start()\n\n", status);
        self.currentSipAccount = nil;
        return MSPMyPjsuaManagerResultRegisterSipServerError;
    }
    
    //Connect success, clear password and add into manager.
    sipAccount.password = @"";
    sipAccount.accountId = @(pjsuaAccountId);
    self.currentSipAccount = sipAccount;
    
    self.status |= MSPMyPjsuaManagerStatusRegisterredSipServer;
    return MSPMyPjsuaManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)makeCall:(MSPPjsuaCall *)call {
    if (!(self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        NSLog(@"\n\nError! pjsua not init, transport not init or not start, please init them before register sip server.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (!(self.status & MSPMyPjsuaManagerStatusRegisterredSipServer)) {
        NSLog(@"\n\nError! Not register a sip server, please register a sip server.\n\n");
        return MSPMyPjsuaManagerResultRegisterSipServerError;
    }
    
    //Hangup same call.
    [self hangupCall:call];
    
    pj_status_t status;
    pj_str_t uri;
    pjsua_call_setting call_opt;
    pjsua_call_id call_id;
    
    uri = pj_str((char *)[[NSString stringWithFormat:@"sip:%@@%@", call.userName, self.currentSipAccount.domain] UTF8String]);
    pjsua_call_setting_default(&call_opt);
    call_opt.vid_cnt = 0;
    call_opt.flag = 0;
    
//    NSLog(@"\n\n----------------- pjsua_call_make_call info -----------------");
//    NSLog(@"acc_id : %d", pjsuaAccountId);
//    NSLog(@"dst_uri : %s", uri.ptr);
//    NSLog(@"call_opt.flag : %d", call_opt.flag);
//    NSLog(@"call_opt.req_keyframe_method : %d", call_opt.req_keyframe_method);
//    NSLog(@"call_opt.aud_cnt : %d", call_opt.aud_cnt);
//    NSLog(@"call_opt.vid_cnt : %d", call_opt.vid_cnt);
//    NSLog(@"------------------------------------------------------------\n\n");
    
    status = pjsua_call_make_call([self.currentSipAccount.accountId intValue], &uri, &call_opt, NULL, NULL, &call_id);
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_call_make_call()\n\n", status);
        return MSPMyPjsuaManagerResultMakeCallError;
    }
    
    call.callId = @(call_id);
    [self.calls setObject:call forKey:call.callId];
    self.currentCall = call;
    
    self.status |= MSPMyPjsuaManagerStatusCalling;
    return MSPMyPjsuaManagerResultSuccess;
}

- (MSPMyPjsuaManagerResult)hangupCall:(MSPPjsuaCall *)call {
    if (!(self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        NSLog(@"\n\nError! pjsua not init, transport not init or not start, please init them before register sip server.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (!(self.status & MSPMyPjsuaManagerStatusRegisterredSipServer)) {
        NSLog(@"\n\nError! Not register a sip server, please register a sip server.\n\n");
        return MSPMyPjsuaManagerResultRegisterSipServerError;
    }
    
    if (!call) {
        return MSPMyPjsuaManagerResultHangupCallError;
    }
    
    MSPPjsuaCall *findCall = self.calls[call.callId];
    if (findCall) {
        pjsua_call_hangup([findCall.callId intValue], 0, NULL, NULL);
        [self.calls removeObjectForKey:findCall.callId];

        if ([self.currentCall.callId isEqualToNumber:findCall.callId]) {
            self.currentCall = nil;
            
            [[NSNotificationCenter defaultCenter] postToMainThreadWithNotificationName:MSPCallhangupNotification object:[MSPMyPjsuaManager sharedManager]];
        }
        
        if (self.calls.count == 0) {
            self.status &= ~MSPMyPjsuaManagerStatusCalling;
        }
        return MSPMyPjsuaManagerResultSuccess;
    }
    else {
        if ([self.currentIncomingCall.callId isEqualToNumber:call.callId]) {
            pjsua_call_hangup([call.callId intValue], 0, NULL, NULL);
            self.currentIncomingCall = nil;
            
            [[NSNotificationCenter defaultCenter] postToMainThreadWithNotificationName:MSPCallhangupNotification object:[MSPMyPjsuaManager sharedManager]];
            
            if (self.calls.count == 0) {
                self.status &= ~MSPMyPjsuaManagerStatusCalling;
            }
            return MSPMyPjsuaManagerResultSuccess;
        }
        else {
            return MSPMyPjsuaManagerResultHangupCallError;
        }
    }
}

- (MSPMyPjsuaManagerResult)answerCall:(MSPPjsuaCall *)call {
    if (!(self.status & MSPMyPjsuaManagerStatusStartedPjsua)) {
        NSLog(@"\n\nError! pjsua not init, transport not init or not start, please init them before register sip server.\n\n");
        return MSPMyPjsuaManagerResultPjsuaNotInitedError;
    }
    
    if (!(self.status & MSPMyPjsuaManagerStatusRegisterredSipServer)) {
        NSLog(@"\n\nError! Not register a sip server, please register a sip server.\n\n");
        return MSPMyPjsuaManagerResultRegisterSipServerError;
    }
    
    //Hangup current call.
    [self hangupCall:self.currentCall];
    
    if (!call) {
        return MSPMyPjsuaManagerResultHangupCallError;
    }
    
    pj_status_t status;
    status = pjsua_call_answer([call.callId intValue], 200, NULL, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"\n\nStatus ID : %d - Error in pjsua_call_answer()\n\n", status);
        return MSPMyPjsuaManagerResultAnswerCallError;
    }
    
    [self.calls setObject:call forKey:call.callId];
    self.currentCall = call;
    self.currentIncomingCall = nil;
    
    [[NSNotificationCenter defaultCenter] postToMainThreadWithNotificationName:MSPCallAnswerNotification object:[MSPMyPjsuaManager sharedManager]];
    
    self.status |= MSPMyPjsuaManagerStatusCalling;
    return MSPMyPjsuaManagerResultSuccess;
}

#pragma mark - PJSUA callback

static void on_call_state(pjsua_call_id call_id, pjsip_event *e) {
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(e);
    
    pjsua_call_get_info(call_id, &ci);
    NSLog(@"\n\n...Call %d state=%s\n\n", call_id, ci.state_text.ptr);
    
    NSLog(@"\n\n----------------- pjsua_call_info incoming info -----------------");
    NSLog(@"id : %d", ci.id);
    NSLog(@"acc_id : %d", ci.acc_id);
    NSLog(@"local_info : %s", ci.local_info.ptr);
    NSLog(@"local_contact : %s", ci.local_contact.ptr);
    NSLog(@"remote_info : %s", ci.remote_info.ptr);
    NSLog(@"remote_contact : %s", ci.remote_contact.ptr);
    NSLog(@"call_id : %s", ci.call_id.ptr);
    NSLog(@"state_text : %s", ci.state_text.ptr);
    NSLog(@"last_status_text : %s", ci.last_status_text.ptr);
    NSLog(@"conf_slot : %d", ci.conf_slot);
    NSLog(@"media_cnt : %d", ci.media_cnt);
    NSLog(@"prov_media_cnt : %d", ci.prov_media_cnt);
    NSLog(@"connect_duration : %ld s, %ld ms", ci.connect_duration.sec, ci.connect_duration.msec);
    NSLog(@"total_duration : %ld s, %ld ms", ci.total_duration.sec, ci.total_duration.msec);
    NSLog(@"rem_offerer : %d", ci.rem_offerer);
    NSLog(@"rem_aud_cnt : %d", ci.rem_aud_cnt);
    NSLog(@"rem_vid_cnt : %d", ci.rem_vid_cnt);
    NSLog(@"------------------------------------------------------------\n\n");
    
    if (ci.state == PJSIP_INV_STATE_DISCONNECTED) {
        MSPPjsuaCall *disconnectCall = [[MSPPjsuaCall alloc] init];
        disconnectCall.callId = @(call_id);
        [[MSPMyPjsuaManager sharedManager] hangupCall:disconnectCall];
    }
}

static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata) {
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(acc_id);
    PJ_UNUSED_ARG(rdata);
    
    //Get calling info.
    pjsua_call_get_info(call_id, &ci);
    NSLog(@"\n\n...Incoming call from %s\n\n", ci.remote_info.ptr);
    
    //If is in calling, reject.
    if ([[MSPMyPjsuaManager sharedManager] currentCall] || [[MSPMyPjsuaManager sharedManager] currentIncomingCall]) {
        pj_str_t reason = pj_str("busy");
        pjsua_call_hangup(call_id, 0, &reason, NULL);
    }
    else {
//        NSLog(@"\n\n----------------- pjsua_call_info incoming info -----------------");
//        NSLog(@"id : %d", ci.id);
//        NSLog(@"acc_id : %d", ci.acc_id);
//        NSLog(@"local_info : %s", ci.local_info.ptr);
//        NSLog(@"local_contact : %s", ci.local_contact.ptr);
//        NSLog(@"remote_info : %s", ci.remote_info.ptr);
//        NSLog(@"remote_contact : %s", ci.remote_contact.ptr);
//        NSLog(@"call_id : %s", ci.call_id.ptr);
//        NSLog(@"state_text : %s", ci.state_text.ptr);
//        NSLog(@"last_status_text : %s", ci.last_status_text.ptr);
//        NSLog(@"conf_slot : %d", ci.conf_slot);
//        NSLog(@"media_cnt : %d", ci.media_cnt);
//        NSLog(@"prov_media_cnt : %d", ci.prov_media_cnt);
//        NSLog(@"connect_duration : %ld s, %ld ms", ci.connect_duration.sec, ci.connect_duration.msec);
//        NSLog(@"total_duration : %ld s, %ld ms", ci.total_duration.sec, ci.total_duration.msec);
//        NSLog(@"rem_offerer : %d", ci.rem_offerer);
//        NSLog(@"rem_aud_cnt : %d", ci.rem_aud_cnt);
//        NSLog(@"rem_vid_cnt : %d", ci.rem_vid_cnt);
//        NSLog(@"------------------------------------------------------------\n\n");
        
        MSPPjsuaCall *incomingCall = [[MSPPjsuaCall alloc] init];
        NSString *info = [NSString stringWithUTF8String:ci.remote_info.ptr];
        NSRange range = [info rangeOfString:@"\""];
        info = [info substringFromIndex:range.location + range.length];
        range = [info rangeOfString:@"\""];
        info = [info substringToIndex:range.location];
        incomingCall.userName = info;
        incomingCall.callId = @(call_id);
        [MSPMyPjsuaManager sharedManager].currentIncomingCall = incomingCall;
        
        [[NSNotificationCenter defaultCenter] postToMainThreadWithNotificationName:MSPCallIncomingNotification object:[MSPMyPjsuaManager sharedManager]];
    }
}

static void on_call_media_state(pjsua_call_id call_id) {
    pjsua_call_info ci;
    
    pjsua_call_get_info(call_id, &ci);
    NSLog(@"\n\n...Call media %d state=%s\n\n", call_id, ci.state_text.ptr);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // When media is active, connect call to sound device.
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
}

//Other PJSUA callbacks, use when need.
//static void on_call_tsx_state(pjsua_call_id call_id, pjsip_transaction *tsx, pjsip_event *e) {
//}
//
//static void on_call_sdp_created(pjsua_call_id call_id, pjmedia_sdp_session *sdp, pj_pool_t *pool, const pjmedia_sdp_session *rem_sdp) {
//}
//
//static void on_stream_created(pjsua_call_id call_id, pjmedia_stream *strm, unsigned stream_idx, pjmedia_port **p_port) {
//}
//
//static void on_stream_destroyed(pjsua_call_id call_id, pjmedia_stream *strm, unsigned stream_idx) {
//}
//
//static void on_dtmf_digit(pjsua_call_id call_id, int digit) {
//}
//
//static void on_call_transfer_request(pjsua_call_id call_id, const pj_str_t *dst, pjsip_status_code *code) {
//}
//
//static void on_call_transfer_request2(pjsua_call_id call_id, const pj_str_t *dst, pjsip_status_code *code, pjsua_call_setting *opt) {
//}
//
//static void on_call_transfer_status(pjsua_call_id call_id, int st_code, const pj_str_t *st_text, pj_bool_t final, pj_bool_t *p_cont) {
//}
//
//static void on_call_replace_request(pjsua_call_id call_id, pjsip_rx_data *rdata, int *st_code, pj_str_t *st_text) {
//}
//
//static void on_call_replace_request2(pjsua_call_id call_id, pjsip_rx_data *rdata, int *st_code, pj_str_t *st_text, pjsua_call_setting *opt) {
//}
//
//static void on_call_replaced(pjsua_call_id old_call_id, pjsua_call_id new_call_id) {
//}
//
//static void on_call_rx_offer(pjsua_call_id call_id, const pjmedia_sdp_session *offer, void *reserved, pjsip_status_code *code, pjsua_call_setting *opt) {
//}
//
//static void on_reg_started(pjsua_acc_id acc_id, pj_bool_t renew) {
//}
//
//static void on_reg_state(pjsua_acc_id acc_id) {
//}
//
//static void on_reg_state2(pjsua_acc_id acc_id, pjsua_reg_info *info) {
//}
//
//static void on_incoming_subscribe(pjsua_acc_id acc_id, pjsua_srv_pres *srv_pres, pjsua_buddy_id buddy_id, const pj_str_t *from, pjsip_rx_data *rdata, pjsip_status_code *code, pj_str_t *reason, pjsua_msg_data *msg_data) {
//}
//
//static void on_srv_subscribe_state(pjsua_acc_id acc_id, pjsua_srv_pres *srv_pres, const pj_str_t *remote_uri, pjsip_evsub_state state, pjsip_event *event) {
//}
//
//static void on_buddy_state(pjsua_buddy_id buddy_id) {
//}
//
//static void on_buddy_evsub_state(pjsua_buddy_id buddy_id, pjsip_evsub *sub, pjsip_event *event) {
//}
//
//static void on_pager(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, const pj_str_t *mime_type, const pj_str_t *body) {
//}
//
//static void on_pager2(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, const pj_str_t *mime_type, const pj_str_t *body, pjsip_rx_data *rdata, pjsua_acc_id acc_id) {
//}
//
//static void on_pager_status(pjsua_call_id call_id, const pj_str_t *to, const pj_str_t *body, void *user_data, pjsip_status_code status, const pj_str_t *reason) {
//}
//
//static void on_pager_status2(pjsua_call_id call_id, const pj_str_t *to, const pj_str_t *body, void *user_data, pjsip_status_code status, const pj_str_t *reason, pjsip_tx_data *tdata, pjsip_rx_data *rdata, pjsua_acc_id acc_id) {
//}
//
//static void on_typing(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, pj_bool_t is_typing) {
//}
//
//static void on_typing2(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, pj_bool_t is_typing, pjsip_rx_data *rdata, pjsua_acc_id acc_id) {
//}
//
//static void on_nat_detect(const pj_stun_nat_detect_result *res) {
//}
//
//static pjsip_redirect_op on_call_redirected(pjsua_call_id call_id, const pjsip_uri *target, const pjsip_event *e) {
//    return PJSIP_REDIRECT_ACCEPT_REPLACE;
//}
//
//static void on_mwi_state(pjsua_acc_id acc_id, pjsip_evsub *evsub) {
//}
//
//static void on_mwi_info(pjsua_acc_id acc_id, pjsua_mwi_info *mwi_info) {
//}
//
//static void on_transport_state(pjsip_transport *tp, pjsip_transport_state state, const pjsip_transport_state_info *info) {
//}
//
//static pj_status_t on_call_media_transport_state(pjsua_call_id call_id, const pjsua_med_tp_state_info *info) {
//    return PJ_SUCCESS;
//}
//
//static void on_ice_transport_error(int index, pj_ice_strans_op op, pj_status_t status, void *param) {
//}
//
//static pj_status_t on_snd_dev_operation(int operation) {
//    return PJ_SUCCESS;
//}
//
//static void on_call_media_event(pjsua_call_id call_id, unsigned med_idx, pjmedia_event *event) {
//}
//
//static pjmedia_transport* on_create_media_transport(pjsua_call_id call_id, unsigned media_idx, pjmedia_transport *base_tp, unsigned flags) {
//    return NULL;
//}
//
//static void on_acc_find_for_incoming(const pjsip_rx_data *rdata, pjsua_acc_id* acc_id) {
//}

@end
