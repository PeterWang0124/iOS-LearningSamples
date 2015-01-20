//
//  SCPlayingCardView.h
//  SuperCard
//
//  Created by PeterWang on 1/19/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPlayingCardView : UIView

@property (strong, nonatomic) NSString *suit;
@property (assign, nonatomic) NSUInteger rank;
@property (assign, nonatomic, getter=isFaceUp) BOOL faceUp;
@property (assign, nonatomic) CGFloat faceScaleFactor;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
