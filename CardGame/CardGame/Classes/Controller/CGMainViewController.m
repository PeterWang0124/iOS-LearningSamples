//
//  CGMainViewController.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGMainViewController.h"

//Model
#import "CGCard.h"
#import "CGPlayingCardDeck.h"
#import "CGCardMatchingGame.h"

//View
#import "CGCardButton.h"

@interface CGMainViewController ()

@property (strong, nonatomic) CGCardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(CGCardButton) NSArray *cardButtons;

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
}

@end
