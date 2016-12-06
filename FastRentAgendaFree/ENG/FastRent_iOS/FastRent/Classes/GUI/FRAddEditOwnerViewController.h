//
//  FRAddEditOwnerViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/23/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRDescriptionTableViewCell.h"
#import "FRPhoneTableViewCell.h"

@class FROwnersViewController, FRAccount;

@interface FRAddEditOwnerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FRDescriptionTableViewCellDelegate, FRPhoneTableViewCellDelegate, UIAlertViewDelegate>

//@property (nonatomic, weak) FRCustomModalViewController *toReturnVC;
@property (nonatomic, strong) FRAccount *account;

@end
