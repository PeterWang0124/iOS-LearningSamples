//
//  SCCardAttribute.h
//  CardGame
//
//  Created by PeterWang on 1/14/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCardAttribute : NSObject

@property (assign, nonatomic, getter=isChosen) BOOL chosen;

- (BOOL)isCardEnable;

@end