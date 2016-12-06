//
//  FRPhoneTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/16/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCommonEditTableViewCell.h"

@class FRPhoneTableViewCell;

@protocol FRPhoneTableViewCellDelegate <NSObject>

@optional

- (void)phoneEditWillUpdate:(FRPhoneTableViewCell *)phoneCell;
- (void)phoneEditDidUpdate:(FRPhoneTableViewCell *)phoneCell;
- (void)phoneCallAction:(FRPhoneTableViewCell *)phoneCell;

@end

@interface FRPhoneTableViewCell : FRCommonEditTableViewCell

@property (nonatomic, weak) id<FRPhoneTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
//@property (weak, nonatomic) IBOutlet UITextField *phoneEdit;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
