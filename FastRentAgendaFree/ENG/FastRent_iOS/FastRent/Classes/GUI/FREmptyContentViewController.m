//
//  FREmptyContentViewController.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 8/7/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FREmptyContentViewController.h"
#import "FRGlobals.h"

@interface FREmptyView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblCenterY;

@end

@interface FREmptyContentViewController ()

@end

@implementation FREmptyContentViewController

- (instancetype)init {
    
    if (!(self = [super init])) 
        return nil;
    
    //_infoLblCenterY = InfoLblCenterYNone;
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    //_infoLblCenterY = InfoLblCenterYNone;

    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.closeBtn.frame = CGRectMake(self.closeBtn.frame.origin.x, self.closeBtn.frame.origin.y - 20, self.closeBtn.frame.size.width, self.closeBtn.frame.size.height);
}

- (IBAction)closeAction:(id)sender {
    
    [self.view removeFromSuperview];
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self.view removeFromSuperview];
//}

@end

@implementation FREmptyView

- (instancetype)init {
    
    if (!(self = [super init]))
        return nil;
    
    _infoLblCenterY = InfoLblCenterYNone;
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    _infoLblCenterY = InfoLblCenterYNone;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _infoLblCenterY = InfoLblCenterYNone;

    return self;
}

- (void)updateConstraints {
    
    [super updateConstraints];
    
    [self removeConstraint:self.lblCenterY];
    
    switch (self.infoLblCenterY) {
        case InfoLblCenterYNone: {
            
            self.lblCenterY = [NSLayoutConstraint constraintWithItem:_infoLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            
            break;
        }
        case InfoLblCenterYWithNavigationBar: {
            
            self.lblCenterY = [NSLayoutConstraint constraintWithItem:_infoLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.12 constant:0];
            
            break;
        }
        default:
            break;
    }
    
    [self addConstraint:self.lblCenterY];
//    self.closeBtnTop.constant = SYSTEM_VERSION_LESS_THAN(@"8.0") ? 42.0 : 62.0;
}

@end
