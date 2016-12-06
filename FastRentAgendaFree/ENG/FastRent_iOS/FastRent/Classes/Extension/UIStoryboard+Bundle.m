//
//  UIStoryboard+Bundle.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 11/2/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "UIStoryboard+Bundle.h"

@implementation UIStoryboard (Bundle)

+ (UIStoryboard *)mainStoryboard {
    
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

@end
