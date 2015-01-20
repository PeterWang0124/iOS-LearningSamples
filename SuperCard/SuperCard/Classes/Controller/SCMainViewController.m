//
//  SCMainViewController.m
//  SuperCard
//
//  Created by PeterWang on 1/19/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCMainViewController.h"

//Model
#import "CGPlayingCardDeck.h"
#import "CGPlayingCard.h"

//View
#import "SCPlayingCardView.h"

@interface SCMainViewController ()

@property (weak, nonatomic) IBOutlet SCPlayingCardView *playingCardView;

@end

@implementation SCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playingCardView.suit = @"♥️";
    self.playingCardView.rank = 13;
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)];
    [self.playingCardView addGestureRecognizer:gesture];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

@end
