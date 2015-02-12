//
//  MSPPjsuaConfig.h
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const MSPDefaultPjsuaTransportProxy;
extern NSUInteger const MSPDefaultPjsuaConsoleLevel;;

typedef NS_ENUM(NSInteger, MSPTransportType) {
    MSPTransportTypeUDP     = 0,
    MSPTransportTypeTCP,
};

@interface MSPPjsuaConfig : NSObject

@property (strong, nonatomic) NSNumber *transportProxy;
@property (assign, nonatomic) MSPTransportType transportype;

@property (strong, nonatomic) NSNumber *consoleLevel;

@end
