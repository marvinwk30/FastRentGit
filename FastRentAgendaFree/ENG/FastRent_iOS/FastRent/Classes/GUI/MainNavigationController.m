//
//  MainNavigationController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "MainNavigationController.h"
#import "FRMyHostingsViewController.h"
#import "UIStoryboard+Bundle.h"
#import "FRGlobals.h"

@interface MainNavigationController ()

//@property (nonatomic, strong) FRMyHostingsViewController *myHostingsVC;

@end

@implementation MainNavigationController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = NAVIGATIONBAR_DEFAULT_COLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONBAR_DEFAULT_TEXT_COLOR, NSForegroundColorAttributeName, NAVIGATION_DEFAULT_FONT, NSFontAttributeName, nil];
    self.navigationBar.titleTextAttributes = attributes;
}

#pragma mark - Private

//- (FRMyHostingsViewController *)myHostingsVC {
//    
//    if (_myHostingsVC != nil) {
//        
//        return _myHostingsVC;
//    }
//    
//    _myHostingsVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRMyHostingsViewController"];
//    
//    return _myHostingsVC;
//}

//#pragma mark - UINavigationControllerDelegate methods
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    if ([viewController isKindOfClass:[FRMyHostingsViewController class]]) {
//        
//        //NSLog(@"YES");
//        self.myHostingsVC.addEditHostingVC.addEditHostingStatus = kAddEditHostingStatusNone;
//    }
//}

@end
