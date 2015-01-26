//
//  DIBezierPathView.m
//  Dropit
//
//  Created by PeterWang on 1/26/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "DIBezierPathView.h"

@implementation DIBezierPathView

- (void)setPath:(UIBezierPath *)path {
    _path = path;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.path stroke];
}

@end
