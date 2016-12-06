//
//  FRFilterViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 4/6/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRDatePickerView.h"

@class FRCustomModalViewController, FRState, FRFilterInfo;

@interface FRFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FRDatePickerProtocol>

@property (nonatomic, weak) FRCustomModalViewController *toReturnVC;
@property (nonatomic, readonly) FRFilterInfo *filterInfo;

@end
