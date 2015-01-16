//
//  CGCardMatchingGameAttribute.h
//  CardGame
//
//  Created by PeterWang on 1/14/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "CGCardAttribute.h"

@interface CGCardMatchingGameAttribute : CGCardAttribute

@property (assign, nonatomic, getter=isMatched) BOOL matched;

@end
