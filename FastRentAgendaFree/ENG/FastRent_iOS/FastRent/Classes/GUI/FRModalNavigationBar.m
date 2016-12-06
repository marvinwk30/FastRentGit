//
//  FRModalNavigationBar.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/31/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRModalNavigationBar.h"

#define kDefaultMarginWidth 8.0

@implementation FRModalNavigationBar

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"UINavigationButton"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            if (view.frame.origin.x < kDefaultMarginWidth) {
                
                view.center = CGPointMake(view.frame.size.width/2 + kDefaultMarginWidth, view.center.y);
            }
            else if (view.frame.origin.x + view.frame.size.width > [UIScreen mainScreen].bounds.size.width - kDefaultMarginWidth) {
                
                view.center = CGPointMake([UIScreen mainScreen].bounds.size.width - view.frame.size.width/2 - kDefaultMarginWidth, view.center.y);
            }
        }
    }
}

@end
