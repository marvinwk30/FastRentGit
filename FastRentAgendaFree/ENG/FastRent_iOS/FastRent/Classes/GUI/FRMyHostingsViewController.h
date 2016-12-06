//
//  FRMyHostingsViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCustomModalViewController.h"
#import "FRAddEditHostingViewController.h"
#import "Types.h"

@class MainNavigationController;

@interface FRMyHostingsViewController : FRCustomModalViewController

@property (nonatomic, weak) MainNavigationController *mainNC;


@end
