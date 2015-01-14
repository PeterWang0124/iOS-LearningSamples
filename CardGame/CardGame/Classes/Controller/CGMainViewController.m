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

//View
#import "CGCardButton.h"

@interface CGMainViewController ()

@property (strong, nonatomic) CGCardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(CGCardButton) NSArray *cardButtons;
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

- (IBAction)touchCardButton:(CGCardButton *)sender {
    NSInteger index = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (void)updateUI {
    for (CGCardButton *button in self.cardButtons) {
        NSInteger index = [self.cardButtons indexOfObject:button];
        CGCard *card = [self.game cardAtIndex:index];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundColor:[self backgroundColorForCard:card]];
        button.enabled = [card.attribute isCardEnable];
    }
    self.gameEndedLabel.hidden = !self.game.isGameEnded;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %zd", self.game.score];
}

- (NSString *)titleForCard:(CGCard *)card {
    return (card.attribute && card.attribute.isChosen) ? card.content : @"";
}

- (UIColor *)backgroundColorForCard:(CGCard *)card {
    if (card.attribute && card.attribute.isChosen) {
        if ([card.attribute isCardEnable]) {
            return [UIColor whiteColor];
        }
        else {
            return [UIColor lightGrayColor];
        }
    }
    else {
        return [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    }
}

@end
