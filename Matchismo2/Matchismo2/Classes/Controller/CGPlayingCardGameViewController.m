//
//  CGPlayingCardGameViewController.m
//  Matchismo2
//
//  Created by PeterWang on 1/15/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGPlayingCardGameViewController.h"

//Model
#import "CGPlayingCardDeck.h"

@interface CGPlayingCardGameViewController ()

@end

@implementation CGPlayingCardGameViewController

- (CGDeck *)createDeck {
    return [[CGPlayingCardDeck alloc] init];
}

@end
