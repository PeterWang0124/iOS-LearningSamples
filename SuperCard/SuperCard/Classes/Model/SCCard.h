//
//  SCCard.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCardAttribute;

@interface SCCard : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) SCCardAttribute *attribute;

- (NSInteger)match:(SCCard *)otherCard;

@end
