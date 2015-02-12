//
//  MSPPjsuaConfig.m
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPPjsuaConfig.h"

NSUInteger const MSPDefaultPjsuaTransportProxy = 5060;
NSUInteger const MSPDefaultPjsuaConsoleLevel = 4;

@implementation MSPPjsuaConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transportProxy = @(MSPDefaultPjsuaTransportProxy);
        self.consoleLevel   = @(MSPDefaultPjsuaConsoleLevel);
    }
    return self;
}

@end
