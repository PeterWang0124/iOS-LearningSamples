//
//  RLLogViewController.h
//  RealmLearning
//
//  Created by PeterWang on 1/7/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RLLogSortType) {
    RLLogSortTypeAToZ       = 0,
    RLLogSortTypeNearToFar  = 1,
    RLLogSortTypeNewToOld   = 2,
};

@interface RLLogViewController : UIViewController

@end
