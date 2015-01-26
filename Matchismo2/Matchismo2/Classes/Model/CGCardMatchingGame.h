//
//  CGCardMatchingGame.h
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CGCardMatchingGameStatus) {
    CGCardMatchingGameStatusPrepareStart = 0,
    CGCardMatchingGameStatusStart,
    CGCardMatchingGameStatusEnded,
};

typedef NS_ENUM(NSInteger, CGCardMatchingGameMode) {
    CGCardMatchingGameModeTwoCardsMatch = 0,
    CGCardMatchingGameModeThreeCardsMatch,
};

@class CGCard;
@class CGDeck;

@interface CGCardMatchingGame : NSObject

@property (assign, nonatomic, readonly) NSInteger score;
@property (assign, nonatomic, readonly) CGCardMatchingGameMode mode;
@property (assign, nonatomic, readonly) CGCardMatchingGameStatus status;
@property (strong, nonatomic, readonly) NSMutableAttributedString *history;

+ (NSString *)gameModeAsString:(CGCardMatchingGameMode)mode;

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(CGDeck *)usingDeck matchMode:(CGCardMatchingGameMode)mode;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (CGCard *)cardAtIndex:(NSUInteger)index;
- (NSString *)scoreAsString;

@end
