//
//  NSDate+MSExcel.m
//  CoreDataImportLearning
//
//  Created by PeterWang on 12/31/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "NSDate+MSExcel.h"

@implementation NSDate (MSExcel)

+ (NSDate *)dateWithExcelSerialDateSince1900:(double)serialdate {
    if (serialdate > 31 + 28)
        serialdate -= 1.0;      // Fix Excel bug where it thinks 1900 is a leap year
    const NSTimeInterval numberOfSecondsInOneDay = 86400;
    NSTimeInterval theTimeInterval = serialdate * numberOfSecondsInOneDay; //number of days
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *excelBaseDateComps = [[NSDateComponents alloc] init];
    [excelBaseDateComps setYear:1900];
    [excelBaseDateComps setMonth:1];
    [excelBaseDateComps setDay:1];
    [excelBaseDateComps setHour:0];
    [excelBaseDateComps setMinute:0];
    [excelBaseDateComps setSecond:0];
    [excelBaseDateComps setTimeZone:timeZone];
    NSDate *excelBaseDate = [calendar dateFromComponents:excelBaseDateComps];
    
    NSDate *inputDate = [NSDate dateWithTimeInterval:theTimeInterval
                                           sinceDate:excelBaseDate];
    
    return inputDate;
}

+ (NSDate *)dateWithExcelSerialDateSince1904:(double)serialdate {
    const NSTimeInterval numberOfSecondsInOneDay = 86400;
    NSTimeInterval theTimeInterval = serialdate * numberOfSecondsInOneDay; //number of days
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *excelBaseDateComps = [[NSDateComponents alloc] init];
    [excelBaseDateComps setYear:1904];
    [excelBaseDateComps setMonth:1];
    [excelBaseDateComps setDay:1];
    [excelBaseDateComps setHour:0];
    [excelBaseDateComps setMinute:0];
    [excelBaseDateComps setSecond:0];
    [excelBaseDateComps setTimeZone:timeZone];
    NSDate *excelBaseDate = [calendar dateFromComponents:excelBaseDateComps];
    
    NSDate *inputDate = [NSDate dateWithTimeInterval:theTimeInterval
                                           sinceDate:excelBaseDate];
    
    return inputDate;
}

@end
