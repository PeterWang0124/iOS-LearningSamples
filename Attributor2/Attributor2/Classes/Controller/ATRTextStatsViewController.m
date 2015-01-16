//
//  ATRTextStatsViewController.m
//  Attributor2
//
//  Created by PeterWang on 1/16/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "ATRTextStatsViewController.h"

@interface ATRTextStatsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *redColorCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenColorCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueColorCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *orangeColorCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;

@end

@implementation ATRTextStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Test code for testing methods(charactersWithAttribute: and charactersWithAttribute:value:).
//    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] init];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"My" attributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSStrokeWidthAttributeName : @-3}]];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Test" attributes:@{NSForegroundColorAttributeName : [UIColor greenColor]}]];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Is" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Going" attributes:@{NSStrokeWidthAttributeName : @-3}]];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Rocks" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor], NSStrokeWidthAttributeName : @-3}]];
//    [testString appendAttributedString:[[NSAttributedString alloc] initWithString:@"!!!" attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor], NSStrokeWidthAttributeName : @-3}]];
//    
//    self.textToAnalyze = testString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)setTextToAnalyze:(NSAttributedString *)textToAnalyze {
    _textToAnalyze = textToAnalyze;
    
    //Update UI when view controller in window.
    if (self.view.window) {
        [self updateUI];
    }
}

- (NSAttributedString *)charactersWithAttribute:(NSString *)attributeName {
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    
    //Find attribute at index to get the effective raise range, then substring form range.
    NSUInteger index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributeName atIndex:index effectiveRange:&range];
        if (value) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        }
        else {
            index++;
        }
    }
    
    return characters;
}

- (NSAttributedString *)charactersWithAttribute:(NSString *)attributeName value:(id)attributeValue {
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    
    //Find attribute at index to get the effective raise range, then substring form range.
    NSUInteger index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributeName atIndex:index effectiveRange:&range];
        if (value && [value isEqual:attributeValue]) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        }
        else {
            index++;
        }
    }
    
    return characters;
}

- (void)updateUI {
    //Get the length of attribute characters.
    NSUInteger colorfulCharactersLength = [[self charactersWithAttribute:NSForegroundColorAttributeName] length];
    NSUInteger redColorCharactersLength = [[self charactersWithAttribute:NSForegroundColorAttributeName value:[UIColor redColor]] length];
    NSUInteger greenColorCharactersLength = [[self charactersWithAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]] length];
    NSUInteger blueColorCharactersLength = [[self charactersWithAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]] length];
    NSUInteger orangeColorCharactersLength = [[self charactersWithAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]] length];
    
    NSUInteger outlinedCharactersLength = [[self charactersWithAttribute:NSStrokeWidthAttributeName] length];
    
    self.colorfulCharactersLabel.text = [NSString stringWithFormat:@"%zd colorful characters.", colorfulCharactersLength];
    self.redColorCharactersLabel.text = [NSString stringWithFormat:@"%zd red color characters.", redColorCharactersLength];
    self.greenColorCharactersLabel.text = [NSString stringWithFormat:@"%zd green color characters.", greenColorCharactersLength];
    self.blueColorCharactersLabel.text = [NSString stringWithFormat:@"%zd blue color characters.", blueColorCharactersLength];
    self.orangeColorCharactersLabel.text = [NSString stringWithFormat:@"%zd orange color characters.", orangeColorCharactersLength];
    
    self.outlinedCharactersLabel.text = [NSString stringWithFormat:@"%zd outlined characters.", outlinedCharactersLength];
}

@end
