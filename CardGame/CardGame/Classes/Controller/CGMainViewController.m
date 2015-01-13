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

//View
#import "CGCardButton.h"

@interface CGMainViewController ()

@property (strong, nonatomic) CGDeck *deck;

@end

@implementation CGMainViewController

- (CGDeck *)deck {
    if (!_deck) {
        _deck = [[CGPlayingCardDeck alloc] init];
    }
    return _deck;
}

- (IBAction)touchCardButton:(CGCardButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0]];
    }
    else {
        CGCard *card = [self.deck drawRandomCard];
        if (card) {
            [sender setTitle:card.content forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor whiteColor]];
        }
    }
}


@end
