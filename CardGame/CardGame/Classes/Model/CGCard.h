//
//  CGCard.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCard : NSObject

@property (strong, nonatomic) NSString *content;

- (NSInteger)match:(NSArray *)otherCards;

@end
