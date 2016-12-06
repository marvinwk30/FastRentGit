//
//  FRAccountImageView.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 7/28/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRAccountImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FRAccountImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    
    self.layer.cornerRadius = self.frame.size.height /2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 3;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
