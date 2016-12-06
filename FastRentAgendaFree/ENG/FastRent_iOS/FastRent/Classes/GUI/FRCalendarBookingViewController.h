//
//  FRCalendarBookingViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "FRCustomModalViewController.h"

@class MainNavigationController;

@interface FRCalendarBookingViewController : FRCustomModalViewController

@property (nonatomic, weak) MainNavigationController *mainNC;

@end
