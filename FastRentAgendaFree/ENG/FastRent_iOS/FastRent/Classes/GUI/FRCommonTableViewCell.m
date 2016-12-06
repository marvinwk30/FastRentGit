//
//  FRCommonTableViewCell.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 6/10/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRCommonTableViewCell.h"

@interface FRCommonTableViewCell ()

//@property (weak, nonatomic) IBOutlet UIView *separatorView;


@end

@implementation FRCommonTableViewCell

- (instancetype)init {
    
    if (!(self = [super init]))
        return nil;
    
    _showSeparator = YES;
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
    _showSeparator = YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
        return nil;
    
    _showSeparator = YES;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.showSeparator) {
    
        CALayer *separator = [CALayer layer];
        separator.backgroundColor = [UIColor colorWithRed:234.0/255.0f green:243.0/255.0f blue:246.0/255.0f alpha:1.0].CGColor;
        separator.frame = CGRectMake(10, self.frame.size.height - 2, self.frame.size.width - 10, 2);
        [self.layer addSublayer:separator];
    }
}

@end
