//
//  UINavigationController+ReplaceStack.h
//  MySIPPhone
//
//  Created by PeterWang on 2/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ReplaceStack)

- (void)replaceLastViewControllerWith:(UIViewController *)controller animated:(BOOL)animated;

@end
