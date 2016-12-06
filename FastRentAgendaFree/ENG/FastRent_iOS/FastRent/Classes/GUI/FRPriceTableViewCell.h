//
//  FRPriceTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 2/22/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCommonEditTableViewCell.h"

@class FRPriceTableViewCell;

@protocol FRPriceTableViewCellDelegate <NSObject>

@optional

- (void)priceEditWillUpdate:(FRPriceTableViewCell *)priceCell;
- (void)priceEditDidUpdate:(FRPriceTableViewCell *)priceCell;

@end

@interface FRPriceTableViewCell : FRCommonEditTableViewCell

@property (nonatomic, weak) id<FRPriceTableViewCellDelegate> delegate;

//@property (weak, nonatomic) IBOutlet UITextField *priceEdit;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLbl;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentImageLeftPadding;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentImageWidth;

@end
