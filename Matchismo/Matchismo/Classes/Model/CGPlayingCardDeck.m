//
//  CGPlayingCardDeck.m
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGPlayingCardDeck.h"

//Model
#import "CGPlayingCard.h"

@implementation CGPlayingCardDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        for (NSString *suit in [CGPlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [CGPlayingCard maxRank]; rank++) {
                CGPlayingCard *card = [[CGPlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
