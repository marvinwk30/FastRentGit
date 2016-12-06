//
//  FRCustomModalViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRState.h"

@interface FRCustomModalViewController : UIViewController

- (void)showAddModalViewControllerAnimated:(BOOL)animate;
- (void)hideAddModalViewControllerAnimated:(BOOL)animate;

- (void)showHostingsListWithStateSelected:(FRState *)selectedHosting;
- (void)showHostingsListWithStatesSelected:(NSArray<FRState *>*)selectedHostings;
- (void)hideHostingsListWithStateSelected:(FRState *)selectedHosting;
- (void)hideHostingsListWithStatesSelected:(NSArray<FRState *>*)selectedHostings;

- (void)showBookingForEditing;
- (void)hideBookingWhenEditingFinish;

- (void)showOwnerForEditing;
- (void)hideOwnerWhenEditingFinish;

@property (nonatomic, strong) UINavigationController *modalNC;
@property (nonatomic, strong) UIViewController *modalVC;

@end
