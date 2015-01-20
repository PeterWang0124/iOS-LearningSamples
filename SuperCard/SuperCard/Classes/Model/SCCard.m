//
//  SCCard.m
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCCard.h"

@implementation SCCard

- (NSInteger)match:(SCCard *)otherCard {
    if ([otherCard.content isEqualToString:self.content]) {
        return 1;
    }
    
    return 0;
}

@end
