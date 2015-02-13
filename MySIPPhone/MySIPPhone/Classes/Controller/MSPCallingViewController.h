//
//  MSPCallingViewController.h
//  MySIPPhone
//
//  Created by PeterWang on 2/13/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSPCallingViewStyle) {
    MSPCallingViewStyleAnswerCall   = 0,
    MSPCallingViewStyleCalling,
};

@interface MSPCallingViewController : UIViewController

@property (assign, nonatomic) MSPCallingViewStyle callingStyle;

@end
