//
//  KSDateUtil.h
//  LeaveRequest
//
//  Created by Kumar Sharma on 05/02/13.
//  Copyright (c) 2013 KSR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDateUtil : NSObject

+ (NSString *)getDateString:(NSString *)dateFormat;
+ (NSString *)getShortDateTimeString:(NSDate*)date;
+ (NSString *)getShortDateOnlyString:(NSDate*)date;
+ (NSString *)getShortDateNameOnlyString:(NSDate*)date;
+ (NSString *)getShortTimeOnlyString:(NSDate*)date;
+ (long)getTimeDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2;
+ (NSString *)getDayNameFromDate:(NSDate *)date;
+ (NSString *)getShortSlashSepDateOnlyString:(NSDate*)date;
+ (NSString *)getMmDdYyyyHhTzDateString:(NSDate*)date;

+ (NSString *)getYYYyMmDdDateFormat:(NSDate*)date;
+ (NSDate *)getNextDayByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate;
+ (int)daysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2;
+ (NSDate *)getCurrentWeeksBeginingDate;
+ (NSDate *)getFirstDayOfCurrentMonth;
+ (NSString *)getDayMonthYearString:(NSDate*)date;
+(NSInteger)getDayDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2;
+ (NSDate *)getNextWeekByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate;
+ (NSDate *)getNextMonthByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate;
+ (NSDate *)getFirstDayOfMonthFromDate:(NSDate *)arbitraryDate;
+ (NSDate *)getDateFromString:(NSString*)date;
+(NSString *)chartTimeForTime:(NSString *)time;
@end
