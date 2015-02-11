//
//  Photo.h
//  Shutterbug2
//
//  Created by PeterWang on 2/2/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSManagedObject *whoTook;

@end
