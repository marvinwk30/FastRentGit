//
//  FRDescriptionTableViewCell.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 2/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDescriptionTableViewCell.h"

@interface FRDescriptionTableViewCell ()

@end

@implementation FRDescriptionTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    
//    if (!(self = [super initWithCoder:aDecoder]))
//        return nil;
//    
//    return self;
//
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(descriptionEditWillUpdate:)]) {
        
        [self.delegate descriptionEditWillUpdate:self];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(descriptionEditDidUpdate:)]) {
        
        [self.delegate descriptionEditDidUpdate:self];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [textField resignFirstResponder];
//    
//    return YES;
//}

- (IBAction)okAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(descriptionEditDidUpdate:)]) {
        
        [self.delegate descriptionEditDidUpdate:self];
    }
    
    [self.componentEdit resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 32;
}


// Fix iOS 7 not editing UITextField
//- (UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
//   
//    return self.descriptionEdit;
//}

@end
