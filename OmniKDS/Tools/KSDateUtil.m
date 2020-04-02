//
//  KSDateUtil.m
//  LeaveRequest
//
//  Created by Kumar Sharma on 05/02/13.
//  Copyright (c) 2013 KSR. All rights reserved.
//

#import "KSDateUtil.h"

@implementation KSDateUtil

//returns the date as string in desired format
+ (NSString *)getDateString:(NSString *)dateFormat
{    
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setCalendar:cal];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    return ret;
}

//returns short date-time string in dd-MM-YYYY, hh:mm a 
+ (NSString *)getShortDateTimeString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY hh:mm:ss a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns short date string in dd-MM-YYYY format
+ (NSString *)getShortDateOnlyString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns short date string in dd-MM-YYYY format
+ (NSString *)getShortSlashSepDateOnlyString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns short date string in YYYY-MM-dd format
+ (NSString *)getYYYyMmDdDateFormat:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns short date string in dd MMM YYYY format. eg. 01 Jan 2013
+ (NSString *)getShortDateNameOnlyString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    [formatter setDateFormat:@"dd MMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns time only. eg 10:00 AM/PM
+ (NSString *)getShortTimeOnlyString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

//returns time difference b/w two dates
+(long)getTimeDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
    long secs = [components second];
    return secs;
}

+(NSInteger)getDayDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger secs = [components day];
    return secs;
}

//returns day name, eg. Thursday
+ (NSString *)getDayNameFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    return dayName;
}

+ (NSString *)getMmDdYyyyHhTzDateString:(NSDate*)date
{
    if(nil == date)
        return nil;
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY HH:mm:ss Z"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    char ch = [stringFromDate characterAtIndex:stringFromDate.length-2];
    if(ch != ':')
    {
        NSMutableString *str = [NSMutableString stringWithString:stringFromDate];
        [str insertString:@":" atIndex:str.length - 2];
        [str replaceOccurrencesOfString:@"+" withString:@"p" options:1 range:NSMakeRange(0, str.length-1)];
        [str replaceOccurrencesOfString:@"-" withString:@"m" options:1 range:NSMakeRange(0, str.length-1)];
        
        stringFromDate = str;
    }
    
    return stringFromDate;
}

+ (NSDate *)getNextDayByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:fromDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    [offsetComponents setDay:nextCount];
    
    NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
    
    return date;
}

+ (NSDate *)getNextMonthByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:fromDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:nextCount];
    NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
    
    return date;
}

+ (NSDate *)getNextWeekByCount:(NSInteger)nextCount fromDate:(NSDate *)fromDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:fromDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    [offsetComponents setWeekday:nextCount];
    
    NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
    
    return date;
}

+ (int)daysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return (int)[components day]+1;
}

+ (NSDate *)getCurrentWeeksBeginingDate
{
    NSDate *today = [NSDate date];
    NSString *dayName = [self getDayNameFromDate:today];
    if([dayName isEqualToString:@"Sunday"])
        today = [self getNextDayByCount:-1 fromDate:today];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
    NSDateComponents *componentsToSubtract  = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: (0 - [weekdayComponents weekday]) + 2];   
    [componentsToSubtract setHour: 0 - [weekdayComponents hour]];
    [componentsToSubtract setMinute: 0 - [weekdayComponents minute]];
    [componentsToSubtract setSecond: 0 - [weekdayComponents second]];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    return beginningOfWeek;
}

+ (NSDate *)getFirstDayOfCurrentMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *arbitraryDate = [NSDate date];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:arbitraryDate];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    return firstDayOfMonthDate;
}

+ (NSDate *)getFirstDayOfMonthFromDate:(NSDate *)arbitraryDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:arbitraryDate];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    return firstDayOfMonthDate;
}

+ (NSString *)getDayMonthYearString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM YY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSDate *)getDateFromString:(NSString*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:mm:ss a"];
    NSDate *d = [formatter dateFromString:date];
    return d;
}

+(NSString *)chartTimeForTime:(NSString *)time
{
    NSArray* keys = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4", @"5",@"6",@"7",@"8",@"9", @"10", @"11",@"12",@"13",@"14", @"15",@"16",@"17",@"18",@"19", @"20",@"21",@"22",@"23",@"24"]];
    
    NSArray* labels = [NSMutableArray arrayWithArray:@[@"1-2 am",@"2-3 am",@"3-4 am",@"4-5 am", @"5-6 am",@"6-7 am",@"7-8 am",@"8-9 am",@"9-10 am", @"10-11 am", @"11-12 am",@"12-1 pm",@"1-2 pm",@"2-3 pm", @"3-4 pm",@"4-5 pm",@"5-6 pm",@"6-7 pm",@"7-8 pm", @"8-9 pm",@"9-10 pm",@"10-11 pm",@"11-12 pm",@"12-1 am"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:labels forKeys:keys];
    return [dict valueForKey:time];
}
@end
