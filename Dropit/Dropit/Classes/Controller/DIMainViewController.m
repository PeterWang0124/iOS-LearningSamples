//
//  DIMainViewController.m
//  Dropit
//
//  Created by PeterWang on 1/21/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "DIMainViewController.h"

//View
#import "DIDropitBehavior.h"
#import "DIBezierPathView.h"

static const CGSize DIDropSize = {40, 40};

@interface DIMainViewController () <UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet DIBezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DIDropitBehavior *dropitBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;

@end

@implementation DIMainViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSInteger width = CGRectGetWidth(self.view.bounds) / DIDropSize.width;
    width *= DIDropSize.width;
    
    NSInteger height = CGRectGetHeight(self.view.bounds) / DIDropSize.height;
    height *= DIDropSize.height;
    
    NSInteger x = (CGRectGetWidth(self.view.bounds) - width) / 2;
    
    CGRect gameFrame;
    gameFrame.origin = CGPointMake(x, 0);
    gameFrame.size = CGSizeMake(width, height);
    self.gameView.frame = gameFrame;
}

#pragma mark - Properties

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (DIDropitBehavior *)dropitBehavior {
    if (!_dropitBehavior) {
        _dropitBehavior  = [[DIDropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

#pragma mark - IBAction

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    gesturePoint = [self pointToLineUpWithPoint:gesturePoint];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

#pragma mark - Game Method

- (void)drop {
    CGRect dropViewFrame;
    dropViewFrame.size = DIDropSize;
    dropViewFrame.origin = [self pointToLineUpWithPoint:CGPointMake(arc4random() % (NSInteger)CGRectGetWidth(self.gameView.bounds), 0)];
    
    UIView *dropView = [[UIView alloc] initWithFrame:dropViewFrame];
    self.droppingView = dropView;
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    [self.dropitBehavior addItem:dropView];
}

- (UIColor *)randomColor {
    switch (arc4random() % 5) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor greenColor];
        case 2:
            return [UIColor blueColor];
        case 3:
            return [UIColor yellowColor];
        case 4:
            return [UIColor purpleColor];
    }
    
    return [UIColor blackColor];
}

- (CGPoint)pointToLineUpWithPoint:(CGPoint)unalignPoint {
    CGPoint alignPoint = unalignPoint;
    NSInteger x = unalignPoint.x / DIDropSize.width;
    alignPoint.x = MIN(MAX(x * DIDropSize.width, 0), CGRectGetWidth(self.gameView.bounds) - DIDropSize.width);
    
    return alignPoint;
}

- (void)attachDroppingViewToPoint:(CGPoint)anchorPoint {
    if (self.droppingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        
        __weak DIMainViewController *weakSelf = self;
        UIView *droppingView = self.droppingView;
        self.attachment.action = ^(void) {
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];  //can't use self.droppingView cause we set nil later.
            weakSelf.gameView.path = path;
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
    }
}

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompleteRows];
}

- (BOOL)removeCompleteRows {
    NSMutableArray *removeDropViews = [[NSMutableArray alloc] init];
    
    //Check rows from bottom row to top row by center point.
    for (CGFloat y = CGRectGetHeight(self.gameView.bounds) - DIDropSize.height / 2; y > 0; y -= DIDropSize.height) {
        BOOL rowIsCompleted = YES;
        NSMutableArray *foundDropViews = [[NSMutableArray alloc] init];
        for (CGFloat x = DIDropSize.width / 2; x < CGRectGetWidth(self.gameView.bounds); x += DIDropSize.width) {
            //Hit Test
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:nil];
            if ([hitView superview] == self.gameView) {
                [foundDropViews addObject:hitView];
            }
            else {
                rowIsCompleted = NO;
                break;
            }
        }
        
        //Toppest row.
        if (![foundDropViews count]) {
            break;
        }
        
        //This row can be removing.
        if (rowIsCompleted) {
            [removeDropViews addObjectsFromArray:foundDropViews];
        }
    }
    
    //Unregister drop behavior and animate to remove the views.
    if ([removeDropViews count]) {
        for (UIView *dropView in removeDropViews) {
            [self.dropitBehavior removeItem:dropView];
        }
        [self animateRemoveDropViews:removeDropViews];
        return YES;
    }
    
    return NO;
}

- (void)animateRemoveDropViews:(NSArray *)removeDropViews {
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *dropView in removeDropViews) {
                             NSInteger x = (arc4random() % (NSInteger)CGRectGetWidth(self.gameView.bounds) * 5) - (NSInteger)CGRectGetWidth(self.gameView.bounds) * 2;
                             NSInteger y = CGRectGetHeight(self.gameView.bounds);
                             dropView.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished) {
                         [removeDropViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

@end
