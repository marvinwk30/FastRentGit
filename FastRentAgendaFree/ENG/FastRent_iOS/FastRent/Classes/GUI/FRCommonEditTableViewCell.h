//
//  FRCommonEditTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/18/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCommonTableViewCell.h"

@interface FRCommonEditTableViewCell : FRCommonTableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *componentEdit;
@property (weak, nonatomic) IBOutlet UILabel *componentDesc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentImageLeftPadding;

- (void)okAction:(id)sender;

@end
