//
//  CGCardMatchingGameAttribute.m
//  CardGame
//
//  Created by PeterWang on 1/14/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardMatchingGameAttribute.h"

@implementation CGCardMatchingGameAttribute

- (BOOL)isCardEnable {
    return !self.matched;
}

@end
