//
//  UISearchBar+EmptySearchText.m
//  RealmLearning
//
//  Created by PeterWang on 1/7/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "UISearchBar+EmptySearchText.h"

@implementation UISearchBar (EmptySearchText)

- (void)resignFirstResponderWithSearchText:(NSString *)text {
    if ([text length] == 0) {
        // The user clicked the [X] button or otherwise cleared the text.
        [self performSelector:@selector(resignFirstResponder)
                   withObject:nil
                   afterDelay:0];
    }
}

@end
