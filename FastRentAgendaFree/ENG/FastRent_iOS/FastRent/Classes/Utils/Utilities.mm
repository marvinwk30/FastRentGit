//
//  Utilities.m
//  FlatUIViewController
//
//  Created by Marvin Avila Kotliarov on 6/18/15.
//  Copyright (c) 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "Utilities.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Detect screen sizes
#define kHeightForiPhone3_5Inches 480.0
#define kHeightForiPhone4Inches 568.0
#define kHeightForiPhone4_7Inches 667.0
#define kHeightForiPhone5_5Inches 736.0
#define kiPhone6PlusScale 3.0

bool IS_WIDESCREEN() { return [UIScreen mainScreen].bounds.size.height - kHeightForiPhone4Inches >= 0.0; }

bool IS_3_5_INCHES() { return [UIScreen mainScreen].bounds.size.height - kHeightForiPhone3_5Inches == 0.0; }

bool IS_4INCHES() { return [UIScreen mainScreen].bounds.size.height - kHeightForiPhone4Inches == 0.0; }

bool IS_4_7INCHES() {return fmax([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height) == kHeightForiPhone4_7Inches; }

bool IS_5_5INCHES() { return fmax([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height) == kHeightForiPhone5_5Inches; }

// Detect devices
bool IS_IPHONE() { return [[UIDevice currentDevice].model isEqualToString: @"iPhone"] || [[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"]; }

bool IS_IPOD() { return [[UIDevice currentDevice].model isEqualToString: @"iPod touch"];}

bool IS_IPHONE_5() { return IS_IPHONE() && IS_4INCHES(); }

bool IS_IPHONE_6() { return IS_IPHONE() && IS_4_7INCHES(); }

bool IS_IPHONE_6_PLUS() { return (IS_IPHONE() && [UIScreen mainScreen].scale == kiPhone6PlusScale); }

bool IS_IPAD() { return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad; }

//UIColor* getColorNavigationBar() { return [UIColor colorWithRed:54.0/255.0f green:202.0/255.0f blue:179.0/255.0f alpha:1.0f]; }

//UIColor* getColorManualLocationRadiusBorder() { return [UIColor colorWithRed:32.0/255.0f green:159.0/255.0f blue:139.0/255.0f alpha:0.5]; } //old green
UIColor* getColorManualLocationRadiusBorder() { return [UIColor colorWithRed:153.0/255.0f green:177.0/255.0f blue:89.0/255.0f alpha:0.5]; } //new green
//UIColor* getColorManualLocationRadiusBorder() { return [UIColor colorWithRed:77.0/255.0f green:77.0/255.0f blue:90.0/255.0f alpha:0.5]; } //new light green

UIColor* getDefaultWhiteColor() { return [UIColor whiteColor]; }

UIColor* getDefaultGreenTextColor() {return [UIColor colorWithRed:153.0/255.0f green:177.0/255.0f blue:89.0/255.0f alpha:1.0]; }

UIColor* getColorCustomDarkGray() { return [UIColor colorWithRed:62.0/255.0f green:62.0/255.0f blue:72.0/255.0f alpha:1.0]; }

UIColor* getColorCustomLightGray() { return [UIColor colorWithRed:77.0/255.0f green:77.0/255.0f blue:90.0/255.0f alpha:1.0]; }