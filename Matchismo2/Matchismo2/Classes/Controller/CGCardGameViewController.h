//
//  CGCardGameViewController.h
//  CardGame
//
//  Created by PeterWang on 1/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//
//  This is the abstract card game view controller class.
//  Most implement methods as described below.

#import <UIKit/UIKit.h>

@class CGDeck;
@interface CGCardGameViewController : UIViewController

//Abstract methods
- (CGDeck *)createDeck;

@end

