//
//  FRAddEditHostingViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRAddEditHostingViewController.h"
#import "FRGlobals.h"
#import "FRLanguage.h"

@interface FRAddEditHostingViewController ()

@end

@implementation FRAddEditHostingViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(okAction:)];
    right.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItem = right;

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    left.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.leftBarButtonItem = left;
    
    self.title = LANG_HOSTING_DETAIL_TITLE;
}

- (void)okAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

@end
