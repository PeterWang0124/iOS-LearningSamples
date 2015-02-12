//
//  MSPLoginTableViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPLoginTableViewController.h"

//Model
#import "MSPMyPjsuaManager.h"

//Controller
#import "MSPTransportTypeTableViewController.h"
#import "MSPMakeCallViewController.h"

@interface MSPLoginTableViewController () <MSPTransportTypeTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *proxyTextField;
@property (weak, nonatomic) IBOutlet UILabel *transportTypeLabel;
@property (assign, nonatomic) MSPTransportType currentTransportType;

@end

@implementation MSPLoginTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([MSPMyPjsuaManager sharedManager].status != MSPMyPjsuaManagerStatusNone) {
        //Close sip manager in new thread.
        [self logoutSip];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MSPTransportTypeTableViewController class]]) {
        ((MSPTransportTypeTableViewController *)segue.destinationViewController).transportTypeDelegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[MSPMakeCallViewController class]]) {
        //Login sip manager in new thread.
        [self loginSip];
    }

    NSLog(@"MSPLoginTableViewController prepareForSegue");
}

#pragma mark - MSPTransportTypeTableViewControllerDelegate

- (void)transportTypeDidSelectedByType:(NSInteger)transportType {
    NSLog(@"transportTypeDidSelectedByType %zd", transportType);
    self.currentTransportType = transportType;
}

#pragma mark -

- (void)loginSip {
    MSPPjsuaConfig *pjsuaConfig = [[MSPPjsuaConfig alloc] init];
    pjsuaConfig.transportProxy = self.proxyTextField.text.length ? @([self.proxyTextField.text integerValue]) : @(MSPDefaultPjsuaTransportProxy);
    pjsuaConfig.transportype = self.currentTransportType;
    
    MSPPjsuaSipAccount *pjsuaSipAccount = [[MSPPjsuaSipAccount alloc] init];
    pjsuaSipAccount.userName = self.userNameTextField.text;
    pjsuaSipAccount.password = self.passwordTextField.text;
    pjsuaSipAccount.domain = self.domainTextField.text;
    
    [[MSPMyPjsuaManager sharedManager] loginWithConfig:pjsuaConfig accountConfig:pjsuaSipAccount];
}

- (void)logoutSip {
    [[MSPMyPjsuaManager sharedManager] logout];
}

@end
