//
//  CGPlayingCard.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGPlayingCard.h"

@implementation CGPlayingCard
@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♣️", @"♦️", @"♥️", @"♠️"];
}

+ (NSArray *)rankString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[CGPlayingCard rankString] count] - 1;
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([[CGPlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [CGPlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)content {
    return [[CGPlayingCard rankString][self.rank] stringByAppendingString:self.suit];
}

- (NSUInteger)match:(CGCard *)otherCard {
    NSUInteger matchStatus = CGPlayingCardMatchStatusNone;
    
    if ([otherCard isKindOfClass:[CGPlayingCard class]]) {
        CGPlayingCard *otherPlayingCard = (CGPlayingCard *)otherCard;
        if (otherPlayingCard.rank == self.rank) {
            matchStatus |= CGPlayingCardMatchStatusRankMatch;
        }
        
        if ([otherPlayingCard.suit isEqualToString:self.suit]) {
            matchStatus |= CGPlayingCardMatchStatusSuitMatch;
        }
    }
    
    return matchStatus;
}

@end
