//
//  CGCardMatchingGame.m
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardMatchingGame.h"

//Model
#import "CGDeck.h"
#import "CGCard.h"
#import "CGCardMatchingGameAttribute.h"

static const NSInteger CGMismatchPenalty = 2;
static const NSInteger CGMatchBonus = 4;
static const NSInteger CGChooseCost = 1;

@interface CGCardMatchingGame ()

@property (assign, nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CGCardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(CGDeck *)usingDeck {
    self = [super init];
    if (self) {
        for (NSUInteger i = 0; i < cardCount; i++) {
            CGCard *card = [usingDeck drawRandomCard];
            if (card) {
                card.attribute = [[CGCardMatchingGameAttribute alloc] init];
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    CGCard *card = [self cardAtIndex:index];
    CGCardMatchingGameAttribute *attribute = (CGCardMatchingGameAttribute *)card.attribute;
    if (!attribute.isMatched) {
        if (attribute.isChosen) {
            attribute.chosen = NO;
        }
        else {
            //Check is match other chosen cards.
            CGCardMatchingGameAttribute *otherCardAttribute = nil;
            for (CGCard *otherCard in self.cards) {
                //Find other chosen and unmatched card to check is match.
                otherCardAttribute = (CGCardMatchingGameAttribute *)otherCard.attribute;
                if (otherCardAttribute.isChosen && !otherCardAttribute.isMatched) {
                    NSInteger matchScore = [card match:otherCard];
                    if (matchScore) {
                        self.score += matchScore * CGMatchBonus;
                        otherCardAttribute.matched = YES;
                        attribute.matched = YES;
                    }
                    else {
                        self.score -= CGMismatchPenalty;
                        
                        //Mismatch,
                        otherCardAttribute.chosen = NO;
                    }
                    
                    //Choose two card
                    break;
                }
            }
            
            self.score -= CGChooseCost;
            attribute.chosen = YES;
        }
    }
}

- (CGCard *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
