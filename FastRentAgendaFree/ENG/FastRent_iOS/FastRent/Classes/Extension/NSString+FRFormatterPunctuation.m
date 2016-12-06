//
//  NSString+FRFormatterPunctuation.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 8/4/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "NSString+FRFormatterPunctuation.h"

@implementation NSString (FRFormatterPunctuation)

- (float)formattedFloatValue {
    
    NSNumber *res;
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.decimalSeparator = @".";
    if ((res = [nf numberFromString:self])) {
        return res.floatValue;
    }
    else {
        nf.decimalSeparator = @",";
//        if let result = nf.numberFromString(self) {
//            return result.floatValue
//        }
        if ((res = [nf numberFromString:self])) {
            return res.floatValue;
        }
    }
    
    return 0;
}

@end
