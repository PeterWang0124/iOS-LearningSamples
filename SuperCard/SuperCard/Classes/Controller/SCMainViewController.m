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

//Test propertis
@property (assign, nonatomic) BOOL animationRunning;

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
        
        //Test flip
//        [UIView transitionWithView:self.playingCardView
//                          duration:5
//                           options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationTransitionFlipFromRight
//                        animations:^{
//                            self.playingCardView.transform = CGAffineTransformMakeScale(-1, 1);
//                        }
//                        completion:nil];
    }
    else {
        //Test flip
//        [UIView transitionWithView:self.playingCardView
//                          duration:5
//                           options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationTransitionFlipFromLeft
//                        animations:^{
//                            self.playingCardView.transform = CGAffineTransformMakeScale(1, 1);
//                        }
//                        completion:nil];
    }
}

- (IBAction)test:(UIButton *)sender {
    //Test 1
//    [UIView animateWithDuration:3 animations:^{
//        self.playingCardView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.playingCardView.alpha = 1.0;
//    }];
//    [self.view setNeedsDisplay];
    
    //Test 2
//    self.animationRunning = !self.animationRunning;
//    if (self.animationRunning) {
//        [self fadeOut:nil finished:nil context:nil];
//    }
//    else {
//        [self fadeIn:nil finished:nil context:nil];
//    }
    
    //Test 3
//    self.animationRunning = !self.animationRunning;
//    if (self.animationRunning) {
//        [UIView animateWithDuration:1
//                              delay:0.0
//                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                         animations:^{
//                             self.playingCardView.alpha = 0.0;
//                         }
//                         completion:nil];
//    }
//    else {
//        [UIView animateWithDuration:1
//                              delay:0.0
//                            options:UIViewAnimationOptionBeginFromCurrentState
//                         animations:^{
//                             self.playingCardView.alpha = 1.0;
//                         }
//                         completion:nil];
//    }
}

- (void)fadeOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeIn:finished:context:)];
    if (self.animationRunning) {
        self.playingCardView.alpha = 0.0;
    }
    else {
        self.playingCardView.alpha = 1.0;
    }
    [UIView commitAnimations];
}

- (void)fadeIn:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    if (self.animationRunning){
        [UIView setAnimationDidStopSelector:@selector(fadeOut:finished:context:)];
    }
    self.playingCardView.alpha = 1.0;
    [UIView commitAnimations];
}

@end
