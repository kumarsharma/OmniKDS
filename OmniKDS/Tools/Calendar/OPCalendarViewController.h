//
//  RangePickerViewController.h
//  FSCalendar
//
//  Created by dingwenchao on 5/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  OPDateSelectionDelegate<NSObject>

@optional
- (void)didSelectDate1:(NSDate *)date1 andDate2:(NSDate *)date2;

@end
@interface OPCalendarViewController : UIViewController
{
    __weak id<OPDateSelectionDelegate> delegate_;
}

@property (nonatomic, weak) id<OPDateSelectionDelegate> delegate;
- (id)initWithDate1:(NSDate *)date_1 Date2:(NSDate *)date_2;
@end
