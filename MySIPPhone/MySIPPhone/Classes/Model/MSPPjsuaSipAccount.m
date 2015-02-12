//
//  MSPPjsuaSipAccount.m
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPPjsuaSipAccount.h"

@implementation MSPPjsuaSipAccount

- (instancetype)init {
    self = [super init];
    if (self) {
        self.realm = @"*";
        self.scheme = @"digest";
    }
    return self;
}

@end
