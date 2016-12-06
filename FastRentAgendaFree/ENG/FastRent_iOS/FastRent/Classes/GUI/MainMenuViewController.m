//
//  ViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 11/16/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIStoryboard+Bundle.h"
#import "LeftMenuTVC.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    /*******************************
     *     Initializing menus
     *******************************/
    //self.leftMenu = [[LeftMenuTVC alloc] initWithNibName:@"LeftMenuTVC" bundle:nil];
    self.leftMenu = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"LeftMenuTVC"];

    /*******************************
     *     End Initializing menus
     *******************************/
    
    self.slideMenuDelegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.panGesture.enabled = NO;
}

bool firstOpened = false;

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!firstOpened) {
     
        [self openLeftMenuAnimated:NO];
        firstOpened = true;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Overriding methods

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
}

- (CGFloat)leftMenuWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

- (BOOL)deepnessForLeftMenu
{
    return YES;
}

- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5f;
}

//- (NSIndexPath *)initialIndexPathForLeftMenu {
//    
//    return [NSIndexPath indexPathForRow:1 inSection:0];
//}

#pragma mark - Slide Menu Delegate

- (void) leftMenuWillOpen
{
    [(LeftMenuTVC*)self.leftMenu updateMenuTitles];
}

@end
