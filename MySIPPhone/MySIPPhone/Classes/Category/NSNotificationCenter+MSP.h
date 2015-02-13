//
//  NSNotificationCenter+MSP.h
//  FunbuddyTalk
//
//  Created by PeterWang on 11/18/14.
//  Copyright (c) 2014 Wayi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MSP)

- (void)postToMainThreadWithNotification:(NSNotification *)notification;
- (void)postToMainThreadWithNotificationName:(NSString *)aName object:(id)anObject;
- (void)postToMainThreadWithNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
