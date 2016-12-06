//
//  FRPriceTableViewCell.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 2/22/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRPriceTableViewCell.h"

@interface FRPriceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation FRPriceTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.componentEdit.keyboardType = UIKeyboardTypeDecimalPad; //UIKeyboardTypeNumberPad;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

#pragma mark - Actions

- (void)okAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(priceEditDidUpdate:)]) {
        
        [self.delegate priceEditDidUpdate:self];
    }
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    self.okButton.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(priceEditWillUpdate:)]) {
        
        [self.delegate priceEditWillUpdate:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
//    self.okButton.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(priceEditWillUpdate:)]) {
        
        [self.delegate priceEditDidUpdate:self];
    }
}

@end
