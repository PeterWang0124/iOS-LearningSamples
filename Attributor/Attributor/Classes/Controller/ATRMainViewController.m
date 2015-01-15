//
//  ATRMainViewController.m
//  Attributor
//
//  Created by PeterWang on 1/15/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "ATRMainViewController.h"

@interface ATRMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation ATRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set outline button's title to be outline words.
    NSMutableAttributedString *outlineTitle = [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    [outlineTitle addAttributes:@{NSStrokeWidthAttributeName:@3, NSStrokeColorAttributeName:self.outlineButton.tintColor} range:NSMakeRange(0, [outlineTitle length])];
    [self.outlineButton setAttributedTitle:outlineTitle forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Use the preferred fonts.
    [self usePreferredFonts];
    
    //Register observer of content size category did change notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredFontsChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //Unregister observer of content size category did change notification.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

#pragma mark - NSNotification push

- (void)preferredFontsChange:(NSNotification *)notification {
    [self usePreferredFonts];
}

#pragma mark - Font settings

- (void)usePreferredFonts {
    self.headlineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.bodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

#pragma mark - IBAction

- (IBAction)changeBodySelectionColorButton:(UIButton *)sender {
    //We change body selection color to match button background color.
    [self.bodyTextView.textStorage addAttribute:NSForegroundColorAttributeName value:sender.backgroundColor range:self.bodyTextView.selectedRange];
}

- (IBAction)outlineBodySelection {
    [self.bodyTextView.textStorage addAttributes:@{NSStrokeWidthAttributeName:@-3, NSStrokeColorAttributeName:[UIColor blackColor]} range:self.bodyTextView.selectedRange];
}

- (IBAction)unoutlineBodySelection {
    [self.bodyTextView.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.bodyTextView.selectedRange];
}

@end
