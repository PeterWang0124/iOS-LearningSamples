//
//  SCPlayingCard.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCPlayingCard.h"

@implementation SCPlayingCard
@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♣️", @"♦️", @"♥️", @"♠️"];
}

+ (NSArray *)rankString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[SCPlayingCard rankString] count] - 1;
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([[SCPlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [SCPlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)content {
    return [[SCPlayingCard rankString][self.rank] stringByAppendingString:self.suit];
}

- (NSInteger)match:(SCCard *)otherCard {
    NSInteger matchScore = 0;
    
    if ([otherCard isKindOfClass:[SCPlayingCard class]]) {
        SCPlayingCard *otherPlayingCard = (SCPlayingCard *)otherCard;
        if (otherPlayingCard.rank == self.rank) {
            matchScore += 2;
        }
        
        if ([otherPlayingCard.suit isEqualToString:self.suit]) {
            matchScore += 1;
        }
    }
    
    return matchScore;
}

@end
