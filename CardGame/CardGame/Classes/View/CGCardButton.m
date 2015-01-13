//
//  CGCardButton.m
//  CardGame
//
//  Created by PeterWang on 1/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardButton.h"

@implementation CGCardButton

- (instancetype)init {
    self = [super init];
    [self setupProperty];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupProperty];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setupProperty];
    return self;
}

- (void)setupProperty {
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

@end
