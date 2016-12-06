//
//  FRNotificationsViewController.h
//  FastRent Agenda Free
//
//  Created by Marvin Avila Kotliarov on 10/17/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCustomModalViewController.h"

@class MainNavigationController;

@interface FRNotificationsViewController : FRCustomModalViewController

@property (nonatomic, weak) MainNavigationController *mainNC;

- (void)reloadInfo;

@end
