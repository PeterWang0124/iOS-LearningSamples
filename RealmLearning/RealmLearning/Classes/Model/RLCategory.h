//
//  RLCategory.h
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLCategory : RLMObject

@property (strong, nonatomic) NSString *name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLCategory>
RLM_ARRAY_TYPE(RLCategory)
