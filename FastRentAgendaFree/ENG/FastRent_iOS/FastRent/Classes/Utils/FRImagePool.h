//
//  MyImagePool.h
//  iAnimalizeFinal
//
//  Created by Emmanuel Ruiz on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FRImagePool : NSObject {

	UIImage *defaultImage;
}

- (UIImage *) getImageAndSave:(NSString *) urlImage;
- (UIImage *) getImageAndSave:(NSString *) aUrlImage  imageName:(NSString*) aImageName;

- (UIImage *)getImageNamed:(NSString *)aImageName;
- (BOOL) saveImageLocally:(UIImage *)image imageName:(NSString *)aImageName;
- (void) removeLocalImage:(NSString*) aImageName;

+ (instancetype) sharedInstance;

@end
