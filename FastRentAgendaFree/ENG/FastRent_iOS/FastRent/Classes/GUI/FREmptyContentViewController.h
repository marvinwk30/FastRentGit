//
//  FREmptyContentViewController.h
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 8/7/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InfoLblCenterY) {
    InfoLblCenterYNone,
    InfoLblCenterYWithNavigationBar,
};

@interface FREmptyView : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (nonatomic, assign) InfoLblCenterY infoLblCenterY;

@end

@interface FREmptyContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
