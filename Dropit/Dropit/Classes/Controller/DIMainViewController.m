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

static const CGSize DIDropSize = {40, 40};

@interface DIMainViewController () <UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DIDropitBehavior *dropitBehavior;

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

#pragma mark - Game Method

- (void)drop {
    CGRect dropViewFrame;
    dropViewFrame.size = DIDropSize;
    NSInteger x = (arc4random() % (NSInteger)CGRectGetWidth(self.gameView.bounds)) / DIDropSize.width;
    dropViewFrame.origin.x = MIN(MAX(x * DIDropSize.width, 0), CGRectGetWidth(self.gameView.bounds) - DIDropSize.width);
    
    UIView *dropView = [[UIView alloc] initWithFrame:dropViewFrame];
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

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"dynamicAnimatorDidPause");
    [self removeCompleteRows];
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"dynamicAnimatorWillResume");
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
