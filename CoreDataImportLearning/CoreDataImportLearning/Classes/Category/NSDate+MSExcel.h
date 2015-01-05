//
//  NSDate+MSExcel.h
//  CoreDataImportLearning
//
//  Created by PeterWang on 12/31/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MSExcel)

+ (NSDate *)dateWithExcelSerialDateSince1900:(double)serialdate;
+ (NSDate *)dateWithExcelSerialDateSince1904:(double)serialdate;

@end
