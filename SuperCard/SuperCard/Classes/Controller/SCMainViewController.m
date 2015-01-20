//
//  SCMainViewController.m
//  SuperCard
//
//  Created by PeterWang on 1/19/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCMainViewController.h"

//Model
#import "SCPlayingCardDeck.h"
#import "SCPlayingCard.h"

//View
#import "SCPlayingCardView.h"

@interface SCMainViewController ()

@property (strong, nonatomic) SCDeck *deck;

@property (weak, nonatomic) IBOutlet SCPlayingCardView *playingCardView;

@end

@implementation SCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)];
    [self.playingCardView addGestureRecognizer:gesture];
}

#pragma mark - Properties

- (SCDeck *)deck {
    if (!_deck) {
        _deck = [[SCPlayingCardDeck alloc] init];
    }
    return _deck;
}

#pragma mark - UI update

- (void)drawRandomPlayingCard {
    SCCard *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SCPlayingCard class]]) {
        SCPlayingCard *playingCard = (SCPlayingCard *)card;
        self.playingCardView.suit = playingCard.suit;
        self.playingCardView.rank = playingCard.rank;
    }
}

#pragma mark - IBAction

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
    if (self.playingCardView.faceUp) {
        [self drawRandomPlayingCard];
    }
}

@end
