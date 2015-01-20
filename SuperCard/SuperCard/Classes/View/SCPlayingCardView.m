//
//  SCPlayingCardView.m
//  SuperCard
//
//  Created by PeterWang on 1/19/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "SCPlayingCardView.h"

static const CGFloat SCCornerFontStandardHeight = 180.0;
static const CGFloat SCCornerRadius = 12.0;
static const CGFloat SCFaceCardScaleFactor = 0.85;

static const CGFloat SCPipFontScaleFactor = 0.012;
static const CGFloat SCPipHorizonOffsetScale = 0.175;
static const CGFloat SCPipVerticalOffsetScaleTop = 0.3;

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
        _faceScaleFactor = SCFaceCardScaleFactor;
    }
    return _faceScaleFactor;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (NSString *)rankAsString {
    NSArray *rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return (self.rank < [rankStrings count]) ? rankStrings[self.rank] : @"?";
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
    return self.bounds.size.height / SCCornerFontStandardHeight;
}

- (CGFloat)cornerRadius {
    return SCCornerRadius * [self cornerScaleFactor];
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
        [self drawPips];
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

- (void)drawPips {
    //Middle pip.
    if ((self.rank == 1) || (self.rank == 3) || (self.rank == 5) || (self.rank == 9)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                                upsideDown:NO];
    }
    
    //Middle symmetrical pips.
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:SCPipHorizonOffsetScale
                            verticalOffset:0
                                upsideDown:NO];
    }
    
    //Middle and upper pips.
    if ((self.rank == 7) || (self.rank == 8)) {
        CGFloat pipVerticalOffsetScaleMidUp = SCPipVerticalOffsetScaleTop / 2;
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:pipVerticalOffsetScaleMidUp
                                upsideDown:NO];
        if (self.rank == 8) {
            [self drawPipsWithHorizontalOffset:0
                                verticalOffset:pipVerticalOffsetScaleMidUp
                                    upsideDown:YES];
        }
    }
    if (self.rank == 10) {
        CGFloat pipVerticalOffsetScaleMidUp = SCPipVerticalOffsetScaleTop * 2 / 3;
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:pipVerticalOffsetScaleMidUp
                                upsideDown:NO];
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:pipVerticalOffsetScaleMidUp
                                upsideDown:YES];
    }
    
    //Top and Bottom Middle pip.
    if ((self.rank == 2) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:SCPipVerticalOffsetScaleTop
                                upsideDown:NO];
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:SCPipVerticalOffsetScaleTop
                                upsideDown:YES];
    }
    
    //Top and Bottom symmetrical pips.
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:SCPipHorizonOffsetScale
                            verticalOffset:SCPipVerticalOffsetScaleTop
                                upsideDown:NO];
        [self drawPipsWithHorizontalOffset:SCPipHorizonOffsetScale
                            verticalOffset:SCPipVerticalOffsetScaleTop
                                upsideDown:YES];
    }
    
    //Upper symmetrical pips.
    if ((self.rank == 9) || (self.rank == 10)) {
        CGFloat pipVerticalOffsetScaleMidUp = SCPipVerticalOffsetScaleTop / 3;
        [self drawPipsWithHorizontalOffset:SCPipHorizonOffsetScale
                            verticalOffset:pipVerticalOffsetScaleMidUp
                                upsideDown:NO];
        [self drawPipsWithHorizontalOffset:SCPipHorizonOffsetScale
                            verticalOffset:pipVerticalOffsetScaleMidUp
                                upsideDown:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown {
    if (upsideDown) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextRotateCTM(context, M_PI);
    }
    
    CGPoint middle = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:pipFont.pointSize * CGRectGetWidth(self.bounds) * SCPipFontScaleFactor];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName : pipFont}];
    
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width / 2 - hoffset * CGRectGetWidth(self.bounds), middle.y - pipSize.height / 2 - voffset * CGRectGetHeight(self.bounds));
    
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset * 2 * CGRectGetWidth(self.bounds);
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown) {
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}

@end
