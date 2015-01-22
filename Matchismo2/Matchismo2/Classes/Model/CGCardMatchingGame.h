//
//  CGCardMatchingGame.h
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CGCardMatchingGameMode) {
    CGCardMatchingGameModeTwoCardsMatch = 0,
    CGCardMatchingGameModeThreeCardsMatch,
};

@class CGCard;
@class CGDeck;

@interface CGCardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(CGDeck *)usingDeck matchMode:(CGCardMatchingGameMode)mode;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (CGCard *)cardAtIndex:(NSUInteger)index;

@property (assign, nonatomic, readonly) NSInteger score;
@property (assign, nonatomic, readonly) CGCardMatchingGameMode mode;
@property (assign, nonatomic, getter=isGameEnded) BOOL gameEnded;

@end
