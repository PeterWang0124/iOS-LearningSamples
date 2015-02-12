//
//  ViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPProcessViewController.h"

//Model
#import "MSPMyPjsuaManager.h"

//NSString * const sipUser = @"102";
//NSString * const sipPassword = @"102";
NSString * const sipUser = @"1002";
NSString * const sipPassword = @"1234";
//NSString * const sipDomain = @"10.2.0.45";
NSString * const sipDomain = @"10.2.0.56";
NSString * const sipCallToUser = @"1001";
//NSUInteger const transportConfigPort = 5060;

@interface MSPProcessViewController ()

@property (strong, nonatomic) MSPPjsuaConfig *pjsuaConfig;
@property (strong, nonatomic) MSPPjsuaSipAccount *pjsuaSipAccount;

@end

@implementation MSPProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pjsuaConfig = [[MSPPjsuaConfig alloc] init];
    
    self.pjsuaSipAccount = [[MSPPjsuaSipAccount alloc] init];
    self.pjsuaSipAccount.userName = sipUser;
    self.pjsuaSipAccount.password = sipPassword;
    self.pjsuaSipAccount.domain = sipDomain;
}

- (void)dealloc {
    [[MSPMyPjsuaManager sharedManager] logout];
}

- (IBAction)initPjsuaButtone:(id)sender {
    
    [[MSPMyPjsuaManager sharedManager] initPjsua:self.pjsuaConfig];
}

- (IBAction)initPjsuaTransportButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] initPjsuaTransport:self.pjsuaConfig];
}

- (IBAction)startPjsuaButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] startPjsua];
}

- (IBAction)registerSipServerButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] registerSipServer:self.pjsuaSipAccount];
}

- (IBAction)makeCallButton:(id)sender {
    MSPPjsuaCall *call = [[MSPPjsuaCall alloc] init];
    call.userName = sipCallToUser;
    [[MSPMyPjsuaManager sharedManager] makeCall:call];
}

@end
