//
//  CGCard.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCard.h"

@implementation CGCard

- (NSUInteger)match:(CGCard *)otherCard {
    if ([otherCard.content isEqualToString:self.content]) {
        return CGCardMatchStatusMatch;
    }
    
    return CGCardMatchStatusNone;
}

@end
