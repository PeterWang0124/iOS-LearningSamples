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

@end

@implementation DIDropitBehavior

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravityBehavior];
        [self addChildBehavior:self.collider];
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

#pragma mark - Item

- (void)addItem:(id<UIDynamicItem>)item {
    [self.gravityBehavior addItem:item];
    [self.collider addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item {
    [self.gravityBehavior removeItem:item];
    [self.collider removeItem:item];
}

@end
