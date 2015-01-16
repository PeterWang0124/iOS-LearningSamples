//
//  CGDeck.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGCard;

@interface CGDeck : NSObject

- (void)addCard:(CGCard *)card;
- (void)addCard:(CGCard *)card atTop:(BOOL)atTop;

- (CGCard *)drawRandomCard;

@end
