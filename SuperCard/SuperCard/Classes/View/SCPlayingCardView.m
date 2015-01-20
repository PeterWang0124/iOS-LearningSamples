//
//  SCPlayingCardView.m
//  SuperCard
//
//  Created by PeterWang on 1/19/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCPlayingCardView.h"

static const CGFloat cornerFontStandardHeight = 180.0;
static const CGFloat cornerRadius = 12.0;
static const CGFloat faceCardScaleFactor = 0.85;

@implementation SCPlayingCardView
@synthesize faceScaleFactor = _faceScaleFactor;

#pragma mark - Initialization

- (void)awakeFromNib {
    [self setup];
}

#pragma mark - Properties

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setFaceScaleFactor:(CGFloat)faceScaleFactor {
    _faceScaleFactor = faceScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)faceScaleFactor {
    if (!_faceScaleFactor) {
        _faceScaleFactor = faceCardScaleFactor;
    }
    return _faceScaleFactor;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

#pragma mark - Gesture action

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing code

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / cornerFontStandardHeight;
}

- (CGFloat)cornerRadius {
    return cornerRadius * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect setLineWidth:2.0];
    [roundedRect stroke];
    
    [self drawCornerCardContents];
}

- (void)drawCornerCardContents {
    if (self.faceUp) {
        [self drawFaceUp];
    }
    else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (void)drawFaceUp {
    /*
     * Draw face.
     */
    NSString *imageName = [NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit];
    UIImage *faceImage = [UIImage imageNamed:imageName];
    if (faceImage) {
        CGRect imageRect = CGRectInset(self.bounds, CGRectGetWidth(self.bounds) * (1.0 - self.faceScaleFactor), CGRectGetHeight(self.bounds) * (1.0 - self.faceScaleFactor));
        [faceImage drawInRect:imageRect];
    }
    else {
        //Draw pips.
    }
    
    /*
     * Draw corner text.
     */
    NSMutableParagraphStyle *paragraphSytle = [[NSMutableParagraphStyle alloc] init];
    paragraphSytle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit];
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphSytle}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    
    //1. Draw corner text.
    //2. Move current context to x = width and y = height, then rotate 180 degree. At this time the drawn corner text is upside down at the right bottom corner.
    //3. Draw corner text again.
    [cornerText drawInRect:textBounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBounds];

}

@end
