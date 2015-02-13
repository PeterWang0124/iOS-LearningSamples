//
//  MSPMakeCallViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPMakeCallViewController.h"

//Model
#import "MSPMyPjsuaManager.h"

//View
#import "JCDialPad.h"
#import "JCPadButton.h"
#import "FontasticIcons.h"

//Controller
#import "MSPCallingViewController.h"

NSString * const MSPCallButtonIdentifier    = @"call";
NSString * const MSPDelButtonIdentifier     = @"del";
NSString * const MSPEmptyButtonIdentifier   = @"empty";

@interface MSPMakeCallViewController () <JCDialPadDelegate>

@property (strong, nonatomic) IBOutlet JCDialPad *dialView;
@property (weak, nonatomic) IBOutlet UITextField *callNumberTextField;

@end

@implementation MSPMakeCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSArray *mains = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", MSPEmptyButtonIdentifier, @"0", MSPDelButtonIdentifier];
    [mains enumerateObjectsUsingBlock:^(NSString *main, NSUInteger idx, BOOL *stop) {
        JCPadButton *button = [[JCPadButton alloc] initWithMainLabel:main subLabel:@""];
        button.borderColor = [UIColor blackColor];
        button.textColor = [UIColor blackColor];
        button.selectedColor = [UIColor lightGrayColor];
        button.hightlightedTextColor = [UIColor whiteColor];
        
        if ([main isEqualToString:MSPEmptyButtonIdentifier]) {
            button.hidden = YES;
        }
        [buttons addObject:button];
    }];
    [buttons addObject:[self callButton]];
    self.dialView.buttons = buttons;
    self.dialView.delegate = self;
    
    self.dialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - JCPadButton

- (JCPadButton *)callButton
{
    FIIconView *iconView = [[FIIconView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.icon = [FIFontAwesomeIcon phoneIcon];
    iconView.padding = 15;
    iconView.iconColor = [UIColor whiteColor];
    JCPadButton *callButton = [[JCPadButton alloc] initWithInput:MSPCallButtonIdentifier iconView:iconView subLabel:@""];
    callButton.backgroundColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    callButton.borderColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    return callButton;
}

#pragma mark - JCDialPadDelegate

- (BOOL)dialPad:(JCDialPad *)dialPad shouldInsertText:(NSString *)text forButtonPress:(JCPadButton *)button {
    if ([text isEqualToString:MSPCallButtonIdentifier]) {
        //Navigate to calling
        MSPCallingViewController *controller = [[MSPCallingViewController alloc] initWithNibName:NSStringFromClass([MSPCallingViewController class]) bundle:[NSBundle mainBundle]];
        
        [self presentViewController:controller animated:YES completion:^{
            //Make Call
            MSPPjsuaCall *call = [[MSPPjsuaCall alloc] init];
            call.userName = self.callNumberTextField.text;
            [[MSPMyPjsuaManager sharedManager] makeCall:call];
        }];
    }
    else if ([text isEqualToString:MSPDelButtonIdentifier]) {
        if (self.callNumberTextField.text.length) {
            self.callNumberTextField.text = [self.callNumberTextField.text substringToIndex:self.callNumberTextField.text.length - 1];
        }
    }
    else {
        self.callNumberTextField.text = [NSString stringWithFormat:@"%@%@", self.callNumberTextField.text, text];
    }
    
    return YES;
}

@end
