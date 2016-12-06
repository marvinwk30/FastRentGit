//
//  FRBookingListTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/28/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCommonTableViewCell.h"

@interface FRBookingListTableViewCell : FRCommonTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *clientsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *statusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

@end
