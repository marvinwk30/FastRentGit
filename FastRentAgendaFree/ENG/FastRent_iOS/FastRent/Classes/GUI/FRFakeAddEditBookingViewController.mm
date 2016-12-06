//
//  FRAddEditBookingViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/30/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRFakeAddEditBookingViewController.h"
#import "FRGlobals.h"
#import "FRLanguage.h"

@interface FRFakeAddEditBookingViewController ()

@end

@implementation FRFakeAddEditBookingViewController

#pragma mark - View lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = LANG_BOOKING_DETAIL_TITLE;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(okAction:)];
    right.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItem = right;

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    left.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (void)okAction:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
