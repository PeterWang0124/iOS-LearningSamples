//
//  SCPlayingCardDeck.m
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCPlayingCardDeck.h"

//Model
#import "SCPlayingCard.h"

@implementation SCPlayingCardDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        for (NSString *suit in [SCPlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [SCPlayingCard maxRank]; rank++) {
                SCPlayingCard *card = [[SCPlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
