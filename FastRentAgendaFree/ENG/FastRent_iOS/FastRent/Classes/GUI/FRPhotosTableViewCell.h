//
//  FRPhotosTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/16/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPhotosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photosImgView;
@property (weak, nonatomic) IBOutlet UIPageControl *photosPgControl;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *delPhotoBtn;

@end
