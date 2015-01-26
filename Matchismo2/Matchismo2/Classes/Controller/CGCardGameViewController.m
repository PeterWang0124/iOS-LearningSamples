//
//  CGCardGameViewController.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardGameViewController.h"

//Model
#import "CGCardGameAttribute.h"
#import "CGCard.h"
#import "CGDeck.h"
#import "CGCardMatchingGame.h"

@interface CGCardGameViewController ()

@property (assign, nonatomic) CGCardMatchingGameMode gameMode;
@property (strong, nonatomic) CGCardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEndedLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *matchModeButton;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameHistoryTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *gameHistoryTextView;

@end

@implementation CGCardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restartButton.layer.cornerRadius = 5.0;
    self.restartButton.layer.borderWidth = 2.0;
    self.restartButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.restartButton.layer.masksToBounds = YES;
    
    self.matchModeButton.layer.cornerRadius = 5.0;
    self.matchModeButton.layer.borderWidth = 2.0;
    self.matchModeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.matchModeButton.layer.masksToBounds = YES;
    
    self.modeLabel.text = [CGCardMatchingGame gameModeAsString:self.gameMode];
    
    self.gameHistoryTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Game History" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    self.gameHistoryTextView.layer.cornerRadius = 5.0;
    self.gameHistoryTextView.layer.borderWidth = 2.0;
    self.gameHistoryTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.gameHistoryTextView.layer.masksToBounds = YES;
    self.gameHistoryTextView.attributedText = self.game.history;
    
    self.scoreLabel.text = [self.game scoreAsString];
}

- (CGCardMatchingGame *)game {
    if (!_game) {
        _game = [[CGCardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] matchMode:self.gameMode];
    }
    return _game;
}

- (CGDeck *)createDeck {
    return nil;
}

- (void)setGameMode:(CGCardMatchingGameMode)gameMode {
    _gameMode = gameMode;
    self.modeLabel.text = [CGCardMatchingGame gameModeAsString:_gameMode];
}

#pragma mark - IBAction

- (IBAction)touchCardButton:(UIButton *)sender {
    NSInteger index = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (IBAction)restartButton:(UIButton *)sender {
    self.game = nil;
    [self updateUI];
}

- (IBAction)changeMatchModeButton:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Match Mode" message:@"Choose the match mode.(WARNING : It will restart the game!!)" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *twoMatchModeAction = [UIAlertAction actionWithTitle:@"Two Cards Match Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.gameMode = CGCardMatchingGameModeTwoCardsMatch;
        self.game = nil;
        [self updateUI];
    }];
    UIAlertAction *threeMatchModeAction = [UIAlertAction actionWithTitle:@"Three Cards Match Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.gameMode = CGCardMatchingGameModeThreeCardsMatch;
        self.game = nil;
        [self updateUI];
    }];
    
    [alert addAction:cancelAction];
    if (self.gameMode != CGCardMatchingGameModeTwoCardsMatch || self.game.status == CGCardMatchingGameStatusPrepareStart) {
        [alert addAction:twoMatchModeAction];
    }
    if (self.gameMode != CGCardMatchingGameModeThreeCardsMatch || self.game.status == CGCardMatchingGameStatusPrepareStart) {
        [alert addAction:threeMatchModeAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Other methods

- (void)updateUI {
    for (UIButton *button in self.cardButtons) {
        NSInteger index = [self.cardButtons indexOfObject:button];
        CGCard *card = [self.game cardAtIndex:index];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        button.enabled = [card.attribute isCardEnable];
    }

    self.gameEndedLabel.hidden = (self.game.status != CGCardMatchingGameStatusEnded);
    self.restartButton.hidden = (self.game.status != CGCardMatchingGameStatusEnded);
    self.scoreLabel.text = [self.game scoreAsString];
    
    NSLog(@"%@", NSStringFromCGSize(self.gameHistoryTextView.contentSize));
    NSLog(@"%@", NSStringFromCGRect(self.gameHistoryTextView.bounds));
    
    self.gameHistoryTextView.attributedText = self.game.history;
    
    NSLog(@"%@", NSStringFromCGSize(self.gameHistoryTextView.contentSize));
    NSLog(@"%@", NSStringFromCGRect(self.gameHistoryTextView.bounds));

//    CGPoint offset = self.gameHistoryTextView.contentOffset;
//    NSLog(@"%@", NSStringFromCGPoint(offset));
    
//    CGPoint offset = CGPointMake(0.0, self.gameHistoryTextView.contentSize.height - CGRectGetHeight(self.gameHistoryTextView.bounds));
//    NSLog(@"%@", NSStringFromCGPoint(offset));
//    [self.gameHistoryTextView setContentOffset:offset animated:YES];
    
//    NSRange range = NSMakeRange(self.game.history.length, 0);
//    [self.gameHistoryTextView scrollRangeToVisible:range];
//    NSLog(@"%@", NSStringFromCGPoint(offset));
}

- (NSString *)titleForCard:(CGCard *)card {
    return (card.attribute && card.attribute.isChosen) ? card.content : @"";
}

- (UIImage *)backgroundImageForCard:(CGCard *)card {
    return (card.attribute && card.attribute.isChosen) ? [UIImage imageNamed:@"cardfront"] : [UIImage imageNamed:@"cardback"];
}

@end
