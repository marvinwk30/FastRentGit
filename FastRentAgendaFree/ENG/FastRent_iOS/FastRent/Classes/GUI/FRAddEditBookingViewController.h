//
//  FRAddEditBookingViewController.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/30/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRDescriptionTableViewCell.h"
#import "FRDatePickerView.h"
#import "FRPriceTableViewCell.h"

typedef enum {
    
    kAddEditBookingStatusNone,
    kAddEditBookingStatusEdit,
    kAddEditBookingStatusModalEdit,
    kAddEditBookingStatusSelectHosting,
    kAddEditBookingStatusModalSelectHosting,
}AddEditBookingStatus;

@class FRCalendarBookingViewController, FRCustomModalViewController, FRBooking;

@interface FRAddEditBookingViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate, UIAlertViewDelegate, FRDescriptionTableViewCellDelegate, FRDatePickerProtocol, FRPriceTableViewCellDelegate>

@property (nonatomic, weak) FRCustomModalViewController *toReturnVC;
@property (nonatomic, strong) FRBooking *booking;
@property (nonatomic, strong) NSDate *checkInDate;

@end
