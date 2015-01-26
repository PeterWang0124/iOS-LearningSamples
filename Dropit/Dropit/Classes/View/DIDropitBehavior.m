//
//  DIDropitBehavior.m
//  Dropit
//
//  Created by PeterWang on 1/21/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "DIDropitBehavior.h"

@interface DIDropitBehavior ()

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;

@end

@implementation DIDropitBehavior

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravityBehavior];
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.animationOptions];
    }

    return self;
}

#pragma mark - Properties

- (UIGravityBehavior *)gravityBehavior {
    if (!_gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc] init];
    }
    return _gravityBehavior;
}

- (UICollisionBehavior *)collider {
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

- (UIDynamicItemBehavior *)animationOptions {
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc] init];
        _animationOptions.allowsRotation = NO;
    }
    return _animationOptions;
}

#pragma mark - Item

- (void)addItem:(id<UIDynamicItem>)item {
    [self.gravityBehavior addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item {
    [self.gravityBehavior removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}

@end
