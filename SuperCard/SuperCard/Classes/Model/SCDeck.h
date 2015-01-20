//
//  SCDeck.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCard;

@interface SCDeck : NSObject

- (void)addCard:(SCCard *)card;
- (void)addCard:(SCCard *)card atTop:(BOOL)atTop;

- (SCCard *)drawRandomCard;

@end
