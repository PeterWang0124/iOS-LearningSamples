//
//  RLCategoryViewController.h
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLCategory;
@class RLCategoryViewController;
@protocol RLCategoryViewControllerDelegate <NSObject>

- (void)RLCategoryViewController:(RLCategoryViewController *)controller didSelectedCategory:(RLCategory *)category;

@end

@interface RLCategoryViewController : UIViewController

@property (weak, nonatomic) id<RLCategoryViewControllerDelegate> delegate;

@end
