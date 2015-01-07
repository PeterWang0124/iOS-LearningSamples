//
//  UISearchBar+EmptySearchText.h
//  RealmLearning
//
//  Created by PeterWang on 1/7/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (EmptySearchText)

- (void)resignFirstResponderWithSearchText:(NSString *)text;

@end
