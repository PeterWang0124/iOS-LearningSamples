//
//  CGCard.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCard.h"

@implementation CGCard

- (NSInteger)match:(NSArray *)otherCards {
    NSInteger matchCount = 0;
    
    //Count the number of match card in other cards.
    for (CGCard *card in otherCards) {
        if ([card.content isEqualToString:self.content]) {
            matchCount++;
        }
    }
    
    return matchCount;
}

@end
