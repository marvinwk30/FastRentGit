//
//  FRTaskRemainingViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCustomModalViewController.h"
#import "FRFilterInfo.h"

@class MainNavigationController;

@interface FRTaskRemainingViewController : FRCustomModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) MainNavigationController *mainNC;

@end
