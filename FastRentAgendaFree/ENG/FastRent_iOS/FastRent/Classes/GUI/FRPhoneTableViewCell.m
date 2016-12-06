//
//  FRPhoneTableViewCell.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/16/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRPhoneTableViewCell.h"

@interface FRPhoneTableViewCell ()

@end

@implementation FRPhoneTableViewCell

#pragma mark - View lifecycle

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.componentEdit.keyboardType = UIKeyboardTypePhonePad;
}

#pragma mark - Actions

- (void)okAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(phoneEditDidUpdate:)]) {
        
        [self.delegate phoneEditDidUpdate:self];
    }
}
- (IBAction)callAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(phoneCallAction:)]) {
        
        [self.delegate phoneCallAction:self];
    }
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //    self.okButton.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(phoneEditWillUpdate:)]) {
        
        [self.delegate phoneEditWillUpdate:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //    self.okButton.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(phoneEditWillUpdate:)]) {

        [self.delegate phoneEditDidUpdate:self];
    }
}

@end
