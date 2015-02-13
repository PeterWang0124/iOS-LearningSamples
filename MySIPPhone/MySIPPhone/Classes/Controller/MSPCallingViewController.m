//
//  MSPCallingViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPCallingViewController.h"

//Category
#import "UINavigationController+ReplaceStack.h"

//Model
#import "MSPMyPjsuaManager.h"

//View
#import "JCDialPad.h"
#import "JCPadButton.h"
#import "FontasticIcons.h"

NSString * const MSPAnswerButtonIdentifier      = @"call";
NSString * const MSPHangupButtonIdentifier      = @"hangup";
NSString * const MSPEmptySpaceButtonIdentifier  = @"empty";

@interface MSPCallingViewController () <JCDialPadDelegate>

@property (strong, nonatomic) IBOutlet JCDialPad *callingDialPad;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation MSPCallingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.callingStyle == MSPCallingViewStyleAnswerCall) {
        self.callingDialPad.buttons = @[[self answerButton], [self emptyButton], [self hangupButton]];
        
        MSPPjsuaCall *incomingCall = [[MSPMyPjsuaManager sharedManager] currentIncomingCall];
        self.userNameLabel.text = incomingCall ? incomingCall.userName : @"Unknown User";
        self.infoLabel.text = @"Incoming...";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCallAnswer:) name:MSPCallAnswerNotification object:nil];
    }
    else if (self.callingStyle == MSPCallingViewStyleCalling) {
        self.callingDialPad.buttons = @[[self hangupButton]];
        
        MSPPjsuaCall *currentCall = [[MSPMyPjsuaManager sharedManager] currentCall];
        self.userNameLabel.text = currentCall ? currentCall.userName : @"Unknown User";
        self.infoLabel.text = @"Talking...";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCallhangup:) name:MSPCallhangupNotification object:nil];
    
    self.callingDialPad.delegate = self;
}

#pragma mark - JCPadButton

- (JCPadButton *)answerButton {
    FIIconView *iconView = [[FIIconView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.icon = [FIFontAwesomeIcon phoneIcon];
    iconView.padding = 15;
    iconView.iconColor = [UIColor whiteColor];
    JCPadButton *button = [[JCPadButton alloc] initWithInput:MSPAnswerButtonIdentifier iconView:iconView subLabel:@""];
    button.backgroundColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    button.borderColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    return button;
}

- (JCPadButton *)hangupButton {
    FIIconView *iconView = [[FIIconView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.icon = [FIFontAwesomeIcon phoneIcon];
    iconView.padding = 15;
    iconView.iconColor = [UIColor whiteColor];
    iconView.transform = CGAffineTransformRotate(iconView.transform, M_PI_2);
    JCPadButton *button = [[JCPadButton alloc] initWithInput:MSPHangupButtonIdentifier iconView:iconView subLabel:@""];
    button.backgroundColor = [UIColor redColor];
    button.borderColor = [UIColor redColor];
    return button;
}

- (JCPadButton *)emptyButton {
    JCPadButton *button = [[JCPadButton alloc] initWithMainLabel:MSPEmptySpaceButtonIdentifier subLabel:@""];
    button.borderColor = [UIColor blackColor];
    button.textColor = [UIColor blackColor];
    button.selectedColor = [UIColor lightGrayColor];
    button.hightlightedTextColor = [UIColor whiteColor];
    button.hidden = YES;
    
    return button;
}

#pragma mark - Notifications

- (void)notifyCallAnswer:(NSNotification *)notification {
    MSPCallingViewController *controller = [[MSPCallingViewController alloc] initWithNibName:NSStringFromClass([MSPCallingViewController class]) bundle:[NSBundle mainBundle]];
    controller.callingStyle = MSPCallingViewStyleCalling;
    [self.navigationController replaceLastViewControllerWith:controller animated:YES];
}

- (void)notifyCallhangup:(NSNotification *)notification {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - JCDialPadDelegate

- (BOOL)dialPad:(JCDialPad *)dialPad shouldInsertText:(NSString *)text forButtonPress:(JCPadButton *)button {
    if ([text isEqualToString:MSPHangupButtonIdentifier]) {
        if (self.callingStyle == MSPCallingViewStyleCalling) {
            MSPPjsuaCall *currentCall = [[MSPMyPjsuaManager sharedManager] currentCall];
            [[MSPMyPjsuaManager sharedManager] hangupCall:currentCall];
        }
        else if (self.callingStyle == MSPCallingViewStyleAnswerCall) {
            MSPPjsuaCall *incomingCall = [[MSPMyPjsuaManager sharedManager] currentIncomingCall];
            [[MSPMyPjsuaManager sharedManager] hangupCall:incomingCall];
        }
    }
    else if ([text isEqualToString:MSPAnswerButtonIdentifier]) {
        MSPPjsuaCall *incomingCall = [[MSPMyPjsuaManager sharedManager] currentIncomingCall];
        [[MSPMyPjsuaManager sharedManager] answerCall:incomingCall];
    }
    
    return YES;
}

@end
