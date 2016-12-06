//
//  UIImage+AssetImage.m
//  FlatUIViewController
//
//  Created by Marvin Avila Kotliarov on 6/18/15.
//  Copyright (c) 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "UIImage+AssetImage.h"
#import "Utilities.h"

#define kAssetImageBaseFileName @"BrandAsset"

#define kAssetImageiOS8Prefix @"-800"
#define kAssetImageiOS7Prefix @"-700"
#define kAssetImagePortraitString @"-Portrait"
#define kAssetImageLandscapeString @"-Landscape"
#define kAssetImageiPadPostfix @"~ipad"


@implementation UIImage (AssetImage)

+ (UIImage *) assetLaunchImage {
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return [UIImage assetLaunchImageWithOrientation:statusBarOrientation useSystemCache: YES];
}

+ (UIImage *) assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)value {
    
    return [UIImage assetImageNamed:kAssetImageBaseFileName orientation:orientation useSystemCache:value];
}

+ (UIImage *) assetImageNamed:(NSString *)name orientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)value {
 
    
    UIScreen *screen  = [UIScreen mainScreen];
    CGFloat screenHeight = fmax(screen.bounds.size.width, screen.bounds.size.height);
    
    //        if (screen.respondsToSelector(Selector("convertRect:toCoordinateSpace:"))) {
    //
    //            screenHeight = screen.coordinateSpace.convertRect(screen.bounds, toCoordinateSpace: screen.fixedCoordinateSpace).size.height
    //        }
    
    CGFloat scale  = screen.scale;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);
    
    NSString *imageNameString = name;
    
    if (IS_IPHONE_6() || IS_IPHONE_6_PLUS()) { // currently here will be launch images for iPhone 6 and 6 plus
        
        imageNameString = [imageNameString stringByAppendingString:kAssetImageiOS8Prefix];
    }
    else {
        
        imageNameString = [imageNameString stringByAppendingString:kAssetImageiOS7Prefix];
    }

    if (IS_IPHONE_6_PLUS() || IS_IPAD()) {
        
        NSString *orientationString = portrait ? kAssetImagePortraitString : kAssetImageLandscapeString;
        imageNameString = [imageNameString stringByAppendingString: orientationString];
    }

    if ((IS_IPHONE() || IS_IPOD()) && IS_WIDESCREEN()) {
        
        imageNameString = [imageNameString stringByAppendingFormat:@"-%dh", (int)screenHeight];// "-\(Int(screenHeight))h"
    }
    
    if (scale > 1) {
        
        imageNameString = [imageNameString stringByAppendingFormat:@"@%dx", (int)scale]; //"@\(Int(scale))x"
    }
    
    if (IS_IPAD()) {
        
        imageNameString = [imageNameString stringByAppendingString:kAssetImageiPadPostfix];
    }

    if (value) {
        
        //NSLog(@"%@", [NSString stringWithFormat:@"%@.png", imageNameString]);
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageNameString]];// (named: imageNameString + ".png")!
    }
    else {
        
        return [UIImage imageWithContentsOfFile:imageNameString];
    }
    
    return nil;
}

@end
