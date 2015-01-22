//
//  CGCard.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CGCardMatchStatus) {
    CGCardMatchStatusNone       = 0,
    CGCardMatchStatusMatch      = 1 << 0,
};

@class CGCardGameAttribute;

@interface CGCard : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) CGCardGameAttribute *attribute;

- (NSUInteger)match:(CGCard *)otherCard;

@end
