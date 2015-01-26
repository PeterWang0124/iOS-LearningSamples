//
//  CGCardMatchingGame.m
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardMatchingGame.h"
#import <UIKit/UIKit.h>

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
@property (assign, nonatomic, readwrite) CGCardMatchingGameStatus status;
@property (strong, nonatomic, readwrite) NSMutableAttributedString *history;
@property (strong, nonatomic) NSMutableArray *cards;

@property (strong, nonatomic) NSMutableParagraphStyle *historyParagraph;
@property (weak, nonatomic) UIFont *historyFont;

@end

@implementation CGCardMatchingGame

+ (NSString *)gameModeAsString:(CGCardMatchingGameMode)mode {
    if (mode == CGCardMatchingGameModeTwoCardsMatch) {
        return @"2-card-match mode";
    }
    else if (mode == CGCardMatchingGameModeThreeCardsMatch) {
        return @"3-card-match mode";
    }
    else {
        return @"Unknown Mode!";
    }
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(CGDeck *)usingDeck matchMode:(CGCardMatchingGameMode)mode {
    self = [super init];
    if (self) {
        self.status = CGCardMatchingGameStatusPrepareStart;
        self.mode = mode;
        self.history = [[NSMutableAttributedString alloc] init];
        
        self.historyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.historyFont = [self.historyFont fontWithSize:14];
        self.historyParagraph = [[NSMutableParagraphStyle alloc] init];
        self.historyParagraph.alignment = NSTextAlignmentCenter;
        
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
    if ((self.status == CGCardMatchingGameStatusEnded)) {
        return;
    }
    NSString *tmpString = nil;
    NSAttributedString *tmpAttributedString = nil;
    
    CGCard *currentCard = [self cardAtIndex:index];
    CGCardMatchingGameAttribute *currentAttribute = (CGCardMatchingGameAttribute *)currentCard.attribute;
    if (!currentAttribute.isMatched) {
        //Game Start!!
        if (self.status == CGCardMatchingGameStatusPrepareStart) {
            self.status = CGCardMatchingGameStatusStart;
//            [self.history appendAttributedString:[[NSAttributedString alloc] initWithString:@"Game Start!!" attributes:@{NSFontAttributeName : self.historyFont, NSParagraphStyleAttributeName : self.historyParagraph, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}]];
        }
        
        //If chosen, set to not chosen.
        //If not chosen, set to chosen.
        currentAttribute.chosen = !currentAttribute.isChosen;
        
        if (currentAttribute.isChosen) {
            //When choose, subtract the choose score.
            self.score -= CGChooseCost;
            tmpString = [NSString stringWithFormat:@"Choose %@\tcost ", currentCard.content];
            tmpAttributedString = [[NSAttributedString alloc] initWithString:tmpString attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [self.history appendAttributedString:tmpAttributedString];
            
            tmpString = [NSString stringWithFormat:@"-%zd points", CGChooseCost];
            tmpAttributedString = [[NSAttributedString alloc] initWithString:tmpString attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            [self.history appendAttributedString:tmpAttributedString];
            
            tmpAttributedString = [[NSAttributedString alloc] initWithString:@".\n" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [self.history appendAttributedString:tmpAttributedString];
        
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
            self.status = CGCardMatchingGameStatusEnded;
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

- (NSString *)scoreAsString {
    return [NSString stringWithFormat:@"Score : %zd", self.score];
}

@end
