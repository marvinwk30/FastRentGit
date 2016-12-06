//
//  INAccordionHeader.m
//  Inmobile
//
//  Created by Marvin Avila Kotliarov on 12/18/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDateHeader.h"

@interface FRDateHeader ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation FRDateHeader

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
    return self;
}

//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    [self bringSubviewToFront:self.separatorView];
//}

@end
