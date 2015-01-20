//
//  SCCardMatchingGameAttribute.m
//  CardGame
//
//  Created by PeterWang on 1/14/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCCardMatchingGameAttribute.h"

@implementation SCCardMatchingGameAttribute

- (BOOL)isCardEnable {
    return !self.matched;
}

@end
