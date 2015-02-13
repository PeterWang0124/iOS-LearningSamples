//
//  NSNotificationCenter+MSP.m
//  FunbuddyTalk
//
//  Created by PeterWang on 11/18/14.
//  Copyright (c) 2014 Wayi. All rights reserved.
//

#import "NSNotificationCenter+MSP.h"

@implementation NSNotificationCenter (MSP)

- (void)postToMainThreadWithNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotification:notification];
    });
}

- (void)postToMainThreadWithNotificationName:(NSString *)aName object:(id)anObject {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotificationName:aName object:anObject];
    });
}

- (void)postToMainThreadWithNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    });
}

@end
