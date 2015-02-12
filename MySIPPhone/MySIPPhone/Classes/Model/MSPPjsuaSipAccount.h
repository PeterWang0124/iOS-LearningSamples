//
//  MSPPjsuaSipAccount.h
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSPPjsuaSipAccount : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;   //Will clear after connect success.
@property (strong, nonatomic) NSNumber *accountId;  //Will get after connect success.
@property (strong, nonatomic) NSString *domain;

@property (strong, nonatomic) NSString *realm;
@property (strong, nonatomic) NSString *scheme;

@end
