//
//  SCDeck.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCDeck.h"

//Model
#import "SCCard.h"

@interface SCDeck ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation SCDeck

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)addCard:(SCCard *)card {
    [self addCard:card atTop:NO];
}

- (void)addCard:(SCCard *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    }
    else {
        [self.cards addObject:card];
    }
}

- (SCCard *)drawRandomCard {
    SCCard *randomCard = nil;
    if ([self.cards count]) {
        NSUInteger index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObject:randomCard];
    }
    
    return randomCard;
}

@end
