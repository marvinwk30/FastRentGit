//
//  FRCustomModalViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRCustomModalViewController.h"

@interface InnerNavigationController : UINavigationController

@end

@implementation InnerNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end

@interface FRCustomModalViewController ()

@end

@implementation FRCustomModalViewController

- (void)viewDidLoad {

    [super viewDidLoad];
}

//- (UINavigationController *)modalNC {
//    
//    if (_modalNC == nil) {
//        
//        _modalNC = [[UINavigationController alloc] initWithRootViewController:self.modalVC];
//    }
//    
//    if (_modalNC.viewControllers == nil || _modalNC.viewControllers.count == 0) {
//        
//        [_modalNC setViewControllers:@[self.modalVC] animated:YES];
//    }
//    
//    return _modalNC;
//}

- (void)showAddModalViewControllerAnimated:(BOOL)animate {

    self.modalNC = [[InnerNavigationController alloc] initWithRootViewController:self.modalVC];
}

- (void)hideAddModalViewControllerAnimated:(BOOL)animate {}

- (void)showHostingsListWithStateSelected:(FRState *)selectedHosting {}
- (void)showHostingsListWithStatesSelected:(NSArray<FRState *>*)selectedHostings {}
- (void)hideHostingsListWithStateSelected:(FRState *)selectedHosting {}
- (void)hideHostingsListWithStatesSelected:(NSMutableArray<FRState *>*)selectedHostings {}

- (void)showBookingForEditing {}
- (void)hideBookingWhenEditingFinish {}

- (void)showOwnerForEditing {}
- (void)hideOwnerWhenEditingFinish {}

@end
