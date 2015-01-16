//
//  CGDeck.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGDeck.h"

//Model
#import "CGCard.h"

@interface CGDeck ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CGDeck

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)addCard:(CGCard *)card {
    [self addCard:card atTop:NO];
}

- (void)addCard:(CGCard *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    }
    else {
        [self.cards addObject:card];
    }
}

- (CGCard *)drawRandomCard {
    CGCard *randomCard = nil;
    if ([self.cards count]) {
        NSUInteger index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObject:randomCard];
    }
    
    return randomCard;
}

@end
