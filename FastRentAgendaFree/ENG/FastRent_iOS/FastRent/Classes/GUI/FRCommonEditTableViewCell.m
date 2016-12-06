//
//  FRCommonEditTableViewCell.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/18/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRCommonEditTableViewCell.h"
#import "FRLanguage.h"

@implementation FRCommonEditTableViewCell

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    return self;
}

- (void)awakeFromNib {
    
    
    [super awakeFromNib];
    
    // Initialization code
    self.componentEdit.delegate = self;
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    accessoryView.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    topView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, [UIScreen mainScreen].bounds.size.width, 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(0, 0, 60, 30);
    [doneBtn setTitle:GENERAL_ALERT_OK_BUTTON_TEXT forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - doneBtn.frame.size.width / 2 - 8,
                                 accessoryView.frame.size.height/2);
    
    [accessoryView addSubview:topView];
    [accessoryView addSubview:bottomView];
    [accessoryView addSubview:doneBtn];
    
    [self.componentEdit setInputAccessoryView:accessoryView];
    
    self.componentEdit.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboard:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)okAction:(id)sender {}

- (void)hideKeyboard:(NSNotification *)note {
    
    //[self.componentEdit resignFirstResponder];
    [self okAction:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.componentEdit.isFirstResponder) {
        
        [self.componentEdit becomeFirstResponder];
    }
}

@end
