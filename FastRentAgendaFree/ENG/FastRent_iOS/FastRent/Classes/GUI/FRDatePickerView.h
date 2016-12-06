//
//  FRDateRangePicker.h
//  FRmobile
//
//  Created by MarvFR Avila Kotliarov on 12/19/15.
//  Copyright © 2015 MarvFR Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Types.h"

@class FRDatePickerView;

@protocol FRDatePickerProtocol <NSObject>

@optional

- (void)datePickerView:(FRDatePickerView *)datePicker didSelectDate:(NSDate *)date;

@end

@interface FRDatePickerView : UIView

//@property (nonatomic, strong) NSMutableOrderedSet *rangeDates;
@property (nonatomic, weak) id<FRDatePickerProtocol> datePickerDelegate;

//@property (nonatomic, weak) UIButton *headerButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end