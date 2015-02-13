//
//  UINavigationController+ReplaceStack.m
//  MySIPPhone
//
//  Created by PeterWang on 2/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "UINavigationController+ReplaceStack.h"

@implementation UINavigationController (ReplaceStack)

- (void)replaceLastViewControllerWith:(UIViewController *)controller animated:(BOOL)animated {
    NSMutableArray *stackViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [stackViewControllers removeLastObject];
    [stackViewControllers addObject:controller];
    [self setViewControllers:stackViewControllers animated:animated];
}

@end
