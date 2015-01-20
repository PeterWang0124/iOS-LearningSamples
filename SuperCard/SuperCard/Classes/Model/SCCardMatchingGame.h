//
//  SCCardMatchingGame.h
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCard;
@class SCDeck;

@interface SCCardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(SCDeck *)usingDeck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (SCCard *)cardAtIndex:(NSUInteger)index;

@property (assign, nonatomic, readonly) NSInteger score;
@property (assign, nonatomic, getter=isGameEnded) BOOL gameEnded;

@end
