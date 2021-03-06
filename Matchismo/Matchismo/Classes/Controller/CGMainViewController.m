//
//  CGMainViewController.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGMainViewController.h"

//Model
#import "CGCardAttribute.h"
#import "CGCard.h"
#import "CGPlayingCardDeck.h"
#import "CGCardMatchingGame.h"

@interface CGMainViewController ()

@property (strong, nonatomic) CGCardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEndedLabel;

@end

@implementation CGMainViewController

- (CGCardMatchingGame *)game {
    if (!_game) {
        _game = [[CGCardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[CGPlayingCardDeck alloc] init]];
    }
    return _game;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSInteger index = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *button in self.cardButtons) {
        NSInteger index = [self.cardButtons indexOfObject:button];
        CGCard *card = [self.game cardAtIndex:index];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        button.enabled = [card.attribute isCardEnable];
    }

    self.gameEndedLabel.hidden = !self.game.isGameEnded;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %zd", self.game.score];
}

- (NSString *)titleForCard:(CGCard *)card {
    return (card.attribute && card.attribute.isChosen) ? card.content : @"";
}

- (UIImage *)backgroundImageForCard:(CGCard *)card {
    return (card.attribute && card.attribute.isChosen) ? [UIImage imageNamed:@"cardfront"] : [UIImage imageNamed:@"cardback"];
}

@end
