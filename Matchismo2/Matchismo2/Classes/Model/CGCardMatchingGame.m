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
@property (assign, nonatomic, readwrite) CGCardMatchingGameMode mode;
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CGCardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(CGDeck *)usingDeck matchMode:(CGCardMatchingGameMode)mode {
    self = [super init];
    if (self) {
        self.mode = mode;
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
    if (self.isGameEnded) {
        return;
    }
    
    CGCard *currentCard = [self cardAtIndex:index];
    CGCardMatchingGameAttribute *currentAttribute = (CGCardMatchingGameAttribute *)currentCard.attribute;
    if (!currentAttribute.isMatched) {
        //If chosen, set to not chosen.
        //If not chosen, set to chosen.
        currentAttribute.chosen = !currentAttribute.isChosen;
        
        if (currentAttribute.isChosen) {
            //When choose, subtract the choose score.
            self.score -= CGChooseCost;
        
            //Get the chosen cards.
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (CGCard *card in self.cards) {
                CGCardMatchingGameAttribute *attribute = (CGCardMatchingGameAttribute *)card.attribute;
                if (attribute.isChosen && !attribute.isMatched) {
                    [chosenCards addObject:card];
                }
            }
            
            //Calculate match status and give score.
            if ((self.mode == CGCardMatchingGameModeTwoCardsMatch && [chosenCards count] == 2) ||
                (self.mode == CGCardMatchingGameModeThreeCardsMatch && [chosenCards count] == 3)) {
                NSUInteger matchStatus = [self totalMatchStatusWithChosenCards:chosenCards];
                if (matchStatus) {
                    self.score += matchStatus * CGMatchBonus * exp2(self.mode + 1);
                }
                else {
                    self.score -= CGMismatchPenalty;
                }
                
                for (CGCard *card in chosenCards) {
                    CGCardMatchingGameAttribute *attribute = (CGCardMatchingGameAttribute *)card.attribute;
                    attribute.matched = matchStatus;
                    attribute.chosen = matchStatus ? YES : (card == currentCard);
                }
            }
        }
        
        //Get unmatch cards to calculate match combinations.
        NSMutableArray *unmatchCards = [[NSMutableArray alloc] init];
        for (CGCard *card in self.cards) {
            CGCardMatchingGameAttribute *attribute = (CGCardMatchingGameAttribute *)card.attribute;
            if (!attribute.isMatched) {
                [unmatchCards addObject:card];
            }
        }
        
        if (![self matchCombinationWithCards:unmatchCards]) {
            self.gameEnded = YES;
            for (CGCard *card in self.cards) {
                CGCardMatchingGameAttribute *attribute = (CGCardMatchingGameAttribute *)card.attribute;
                attribute.chosen = YES;
            }
        }
    }
}

- (NSUInteger)totalMatchStatusWithChosenCards:(NSArray *)chosenCards {
    NSUInteger totalMatchStatus = 0;
    
    BOOL firstMatch = YES;
    for (NSUInteger i = 0; i < [chosenCards count] - 1; i++) {
        for (NSUInteger j = [chosenCards count] - 1; j > i; j--) {
            if (firstMatch) {
                totalMatchStatus = [chosenCards[i] match:chosenCards[j]];
                firstMatch = NO;
            }
            else {
                totalMatchStatus &= [chosenCards[i] match:chosenCards[j]];
            }
        }
    }

    return totalMatchStatus;
}

- (NSUInteger)matchCombinationWithCards:(NSArray *)cards {
    NSMutableArray *combination = [[NSMutableArray alloc] init];
    if (self.mode == CGCardMatchingGameModeTwoCardsMatch && [cards count] > 1) {
        return [self matchCountWithSourceArray:cards startIndex:0 maxCominationCount:2 tmpCombination:combination];
    }
    else if (self.mode == CGCardMatchingGameModeThreeCardsMatch && [cards count] > 2) {
        return [self matchCountWithSourceArray:cards startIndex:0 maxCominationCount:3 tmpCombination:combination];
    }
    
    return 0;
}

- (NSUInteger)matchCountWithSourceArray:(NSArray *)srcArray startIndex:(NSUInteger)startIndex maxCominationCount:(NSUInteger)maxCombinationCount tmpCombination:(NSMutableArray *)array {
    if ([array count] == maxCombinationCount) {
        NSUInteger matchStatus = [self totalMatchStatusWithChosenCards:array];
        [array removeLastObject];
        return matchStatus ? 1 : 0;
    }
    
    NSUInteger combinationCount = 0;
    for (NSUInteger i = startIndex; i < [srcArray count]; i++) {
        [array addObject:srcArray[i]];
        combinationCount += [self matchCountWithSourceArray:srcArray startIndex:i + 1 maxCominationCount:maxCombinationCount tmpCombination:array];
    }
    
    [array removeLastObject];
    return combinationCount;
}

- (CGCard *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
