//
//  INDateRangePicker.m
//  Inmobile
//
//  Created by Marvin Avila Kotliarov on 12/19/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDatePickerView.h"
#import "FRLanguage.h"

@interface FRDatePickerView ()

@end

@implementation FRDatePickerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
//    _rangeDates = [NSMutableOrderedSet orderedSet];
    
    return self;
}

- (IBAction)dateChanged:(id)sender {
    
    if ([self.datePickerDelegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        
        [self.datePickerDelegate datePickerView:self didSelectDate:((UIDatePicker *)sender).date];
    }
}

@end
