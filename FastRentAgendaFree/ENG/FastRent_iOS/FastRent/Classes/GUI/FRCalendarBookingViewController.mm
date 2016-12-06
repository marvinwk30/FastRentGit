//
//  FRCalendarBookingViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRCalendarBookingViewController.h"
#import "FRFakeAddEditBookingViewController.h"
#import "UIStoryboard+Bundle.h"
#import "FREmptyContentViewController.h"
#import "Utilities.h"
#import "FRLanguage.h"

@interface FRCalendarBookingViewController ()

@property (nonatomic, strong) FRFakeAddEditBookingViewController *addEditBookingVC;
@property (nonatomic, strong) FREmptyContentViewController *emptyContentVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legendHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookingDetailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;

@end

@implementation FRCalendarBookingViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = LANG_TITLE_CALENDAR_BOOKING;
    
    if (IS_IPHONE_6_PLUS()) {
        
        self.legendHeight.constant = 49;
        self.bookingDetailHeight.constant = 163;
        self.calendarHeight.constant = 682;
    }
    else if (IS_IPHONE_6()){
        
        self.bookingDetailHeight.constant = 144;
        self.legendHeight.constant = 38;
        self.calendarHeight.constant = 600;
    }
    else {
        
        self.legendHeight.constant = 38;
        self.bookingDetailHeight.constant = 127;
        self.calendarHeight.constant = 528;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.emptyContentVC.view];
    
    self.emptyContentVC.closeBtn.hidden = NO;
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.textColor = [UIColor whiteColor];
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.textAlignment = NSTextAlignmentLeft;
    self.emptyContentVC.view.backgroundColor = [UIColor darkGrayColor];
    self.emptyContentVC.view.alpha = 0.95;
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.text = LANG_CALENDAR_OVERLAY_TEXT;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    
        CGFloat height = [((FREmptyView *)self.emptyContentVC.view).infoLbl.text boundingRectWithSize:CGSizeMake(((FREmptyView *)self.emptyContentVC.view).infoLbl.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:((FREmptyView *)self.emptyContentVC.view).infoLbl.font} context:nil].size.height;
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.numberOfLines = (int)ceilf(height/((FREmptyView *)self.emptyContentVC.view).infoLbl.font.pointSize);
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.frame = CGRectMake(((FREmptyView *)self.emptyContentVC.view).infoLbl.frame.origin.x, ([UIScreen mainScreen].bounds.size.height - 20 - height)/2 + 44.0, ((FREmptyView *)self.emptyContentVC.view).infoLbl.frame.size.width, height);
    }
}

- (FREmptyContentViewController *)emptyContentVC {
    
    if (_emptyContentVC == nil) {
        
        _emptyContentVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
        ((FREmptyView *)_emptyContentVC.view).infoLblCenterY = InfoLblCenterYWithNavigationBar;
    }
    
    return _emptyContentVC;
}

- (FRFakeAddEditBookingViewController *)addEditBookingVC {
    
    if (_addEditBookingVC == nil) {
        
        _addEditBookingVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRFakeAddEditBookingViewController"];
    }
    
    return _addEditBookingVC;
}

- (IBAction)bookingAction:(id)sender {
    
    [self.navigationController pushViewController:self.addEditBookingVC animated:YES];
}

@end
