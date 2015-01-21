//
//  DIDropitBehavior.h
//  Dropit
//
//  Created by PeterWang on 1/21/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIDropitBehavior : UIDynamicBehavior

- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;

@end
