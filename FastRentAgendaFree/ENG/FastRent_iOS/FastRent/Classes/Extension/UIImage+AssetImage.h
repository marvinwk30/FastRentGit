//
//  UIImage+AssetImage.h
//  FlatUIViewController
//
//  Created by Marvin Avila Kotliarov on 6/18/15.
//  Copyright (c) 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AssetImage)

+ (UIImage *) assetLaunchImage;

+ (UIImage *) assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)value;

+ (UIImage *) assetImageNamed:(NSString *)name orientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)value;

@end
