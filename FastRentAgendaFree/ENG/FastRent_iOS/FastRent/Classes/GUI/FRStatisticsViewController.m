//
//  FRStatisticsViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/26/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRStatisticsViewController.h"
#import "MainNavigationController.h"
#import "FRLanguage.h"
#import "UIStoryboard+Bundle.h"
#import "FRGlobals.h"
#import "FREmptyContentViewController.h"

@interface FRStatisticsViewController ()

@property (nonatomic, strong) FREmptyContentViewController *emptyContentVC;

@end

@implementation FRStatisticsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = LANG_TITLE_REPORTS;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.emptyContentVC.view];
    
    self.emptyContentVC.closeBtn.hidden = NO;
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.textColor = [UIColor whiteColor];
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.textAlignment = NSTextAlignmentLeft;
    self.emptyContentVC.view.backgroundColor = [UIColor darkGrayColor];
    self.emptyContentVC.view.alpha = 0.95;
    ((FREmptyView *)self.emptyContentVC.view).infoLbl.text = LANG_STATISTICS_OVERLAY_TEXT;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        CGFloat height = [((FREmptyView *)self.emptyContentVC.view).infoLbl.text boundingRectWithSize:CGSizeMake(((FREmptyView *)self.emptyContentVC.view).infoLbl.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:((FREmptyView *)self.emptyContentVC.view).infoLbl.font} context:nil].size.height;
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.numberOfLines = (int)ceilf(height/((FREmptyView *)self.emptyContentVC.view).infoLbl.font.pointSize);
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.frame = CGRectMake(((FREmptyView *)self.emptyContentVC.view).infoLbl.frame.origin.x, ([UIScreen mainScreen].bounds.size.height - 20 - height)/2 + 44.0, ((FREmptyView *)self.emptyContentVC.view).infoLbl.frame.size.width, height);
    }
}

#pragma mark - Getters and Setters

- (FREmptyContentViewController *)emptyContentVC {
    
    if (_emptyContentVC == nil) {
        
        _emptyContentVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
        ((FREmptyView *)_emptyContentVC.view).infoLblCenterY = InfoLblCenterYWithNavigationBar;
    }
    
    return _emptyContentVC;
}

@end
