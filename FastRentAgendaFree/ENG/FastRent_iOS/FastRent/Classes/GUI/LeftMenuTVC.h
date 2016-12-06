//
//  LeftMenuTVC.h
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"

@class FRNotificationsViewController, FRCalendarBookingViewController;

@interface LeftMenuTVC : AMSlideMenuLeftTableViewController

#pragma mark - Properties
@property (strong, nonatomic) NSMutableArray *tableData;
@property (nonatomic, strong) FRNotificationsViewController *notificationsVC;
@property (nonatomic, strong) FRCalendarBookingViewController *calendarBookingVC;

- (void) updateMenuTitles;

@end
