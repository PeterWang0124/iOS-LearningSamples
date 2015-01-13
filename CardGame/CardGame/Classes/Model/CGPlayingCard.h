//
//  CGPlayingCard.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCard.h"

@interface CGPlayingCard : CGCard

@property (strong, nonatomic) NSString *suit;
@property (assign, nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankString;
+ (NSUInteger)maxRank;

@end
