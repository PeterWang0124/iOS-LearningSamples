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

NSString * const callButtonIdentifier = @"call";
NSString * const delButtonIdentifier = @"del";
NSString * const emptyButtonIdentifier = @"empty";

@interface MSPMakeCallViewController () <JCDialPadDelegate>

@property (strong, nonatomic) IBOutlet JCDialPad *dialView;
@property (weak, nonatomic) IBOutlet UITextField *callNumberTextField;

@end

@implementation MSPMakeCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSArray *mains = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", emptyButtonIdentifier, @"0", delButtonIdentifier];
    [mains enumerateObjectsUsingBlock:^(NSString *main, NSUInteger idx, BOOL *stop) {
        JCPadButton *button = [[JCPadButton alloc] initWithMainLabel:main subLabel:@""];
        button.borderColor = [UIColor blackColor];
        button.textColor = [UIColor blackColor];
        button.selectedColor = [UIColor lightGrayColor];
        button.hightlightedTextColor = [UIColor whiteColor];
        
        if ([main isEqualToString:emptyButtonIdentifier]) {
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
    JCPadButton *callButton = [[JCPadButton alloc] initWithInput:callButtonIdentifier iconView:iconView subLabel:@""];
    callButton.backgroundColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    callButton.borderColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    return callButton;
}

#pragma mark - JCDialPadDelegate

- (BOOL)dialPad:(JCDialPad *)dialPad shouldInsertText:(NSString *)text forButtonPress:(JCPadButton *)button {
    NSLog(@"shouldInsertText: %@ forButtonPress: %@", text, button.input);
    if ([text isEqualToString:callButtonIdentifier]) {
        //Make Call
        MSPPjsuaCall *call = [[MSPPjsuaCall alloc] init];
        call.userName = self.callNumberTextField.text;
        [[MSPMyPjsuaManager sharedManager] makeCall:call];
    }
    else if ([text isEqualToString:delButtonIdentifier]) {
        if (self.callNumberTextField.text.length) {
            self.callNumberTextField.text = [self.callNumberTextField.text substringToIndex:self.callNumberTextField.text.length - 1];
        }
    }
    else {
        self.callNumberTextField.text = [NSString stringWithFormat:@"%@%@", self.callNumberTextField.text, text];
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
