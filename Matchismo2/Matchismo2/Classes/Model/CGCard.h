//
//  CGCard.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGCardAttribute;

@interface CGCard : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) CGCardAttribute *attribute;

- (NSInteger)match:(CGCard *)otherCard;

@end
