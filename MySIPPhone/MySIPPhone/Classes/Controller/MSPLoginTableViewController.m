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
#import "MSPCallingViewController.h"

@interface MSPLoginTableViewController () <UITextFieldDelegate, MSPTransportTypeTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *proxyTextField;
@property (weak, nonatomic) IBOutlet UILabel *transportTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *callToTextField;
@property (weak, nonatomic) IBOutlet UIButton *callingButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (assign, nonatomic) MSPTransportType currentTransportType;

@end

@implementation MSPLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.callingButton.layer.borderColor = [self.callingButton.titleLabel.textColor CGColor];
    self.callingButton.layer.borderWidth = 1.0;
    self.callingButton.layer.cornerRadius = 5.0;
    self.callingButton.layer.masksToBounds = YES;
    
    self.loginButton.layer.borderColor = [self.loginButton.titleLabel.textColor CGColor];
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.layer.masksToBounds = YES;
    
    self.logoutButton.layer.borderColor = [self.loginButton.titleLabel.textColor CGColor];
    self.logoutButton.layer.borderWidth = 1.0;
    self.logoutButton.layer.cornerRadius = 5.0;
    self.logoutButton.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCallIncoming:) name:MSPCallIncomingNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([MSPMyPjsuaManager sharedManager].status != MSPMyPjsuaManagerStatusNone) {
        [self logoutSip];
        [self updateUI:NO];
    }
}

- (void)updateUI:(BOOL)isLogon {
    if (isLogon) {
        self.loginButton.hidden = YES;
        self.callingButton.enabled = NO;
        self.logoutButton.hidden = NO;
    }
    else {
        self.loginButton.hidden = NO;
        self.callingButton.enabled = YES;
        self.logoutButton.hidden = YES;
    }
    self.callingButton.layer.borderColor = [self.callingButton.titleLabel.textColor CGColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TransportChoose"] &&
        [segue.destinationViewController isKindOfClass:[MSPTransportTypeTableViewController class]]) {
        ((MSPTransportTypeTableViewController *)segue.destinationViewController).transportTypeDelegate = self;
        [self onBackgroungHit:nil];
    }

    NSLog(@"MSPLoginTableViewController prepareForSegue");
}

#pragma mark - UITextFieldDelegate

- (IBAction)doEditFieldDone:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)onBackgroungHit:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.domainTextField resignFirstResponder];
    [self.proxyTextField resignFirstResponder];
    [self.callToTextField resignFirstResponder];
}

#pragma mark - MSPTransportTypeTableViewControllerDelegate

- (void)transportTypeDidSelectedByType:(NSInteger)transportType {
    NSLog(@"transportTypeDidSelectedByType %zd", transportType);
    self.currentTransportType = transportType;
}


- (IBAction)clickCallingButton {
    [self onBackgroungHit:nil];
    if (self.logoutButton.hidden) {
        [self loginSip];
        if ([MSPMyPjsuaManager sharedManager].status & MSPMyPjsuaManagerStatusRegisterredSipServer) {
            //Login success
            [self updateUI:(self.callToTextField.text.length)];
            
            //Make call
            [self makeCall];
            
            MSPCallingViewController *controller = [[MSPCallingViewController alloc] initWithNibName:NSStringFromClass([MSPCallingViewController class]) bundle:[NSBundle mainBundle]];
            controller.callingStyle = MSPCallingViewStyleCalling;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            //Login failed
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login failed" message:@"There has problem on connect to server." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)clickLoginButton {
    [self onBackgroungHit:nil];
    if (self.logoutButton.hidden) {
        [self loginSip];
        if ([MSPMyPjsuaManager sharedManager].status & MSPMyPjsuaManagerStatusRegisterredSipServer) {
            //Login success
            [self updateUI:YES];
        }
        else {
            //Login failed
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login failed" message:@"There has problem on connect to server." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)clickLogoutButton {
    [self logoutSip];
    [self updateUI:NO];
}

- (void)notifyCallIncoming:(NSNotification *)notification {
    MSPCallingViewController *controller = [[MSPCallingViewController alloc] initWithNibName:NSStringFromClass([MSPCallingViewController class]) bundle:[NSBundle mainBundle]];
    controller.callingStyle = MSPCallingViewStyleAnswerCall;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SIP Process

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

- (void)makeCall {
    if (self.callToTextField.text.length) {
        MSPPjsuaCall *call = [[MSPPjsuaCall alloc] init];
        call.userName = self.callToTextField.text;
        [[MSPMyPjsuaManager sharedManager] makeCall:call];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Make call failed" message:@"Call to is empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)logoutSip {
    [[MSPMyPjsuaManager sharedManager] logout];
}

@end
