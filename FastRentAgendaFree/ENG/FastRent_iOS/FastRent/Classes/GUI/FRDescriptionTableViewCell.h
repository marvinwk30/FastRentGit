//
//  FRDescriptionTableViewCell.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 2/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCommonEditTableViewCell.h"

@class FRDescriptionTableViewCell;

@protocol FRDescriptionTableViewCellDelegate <NSObject>

@optional

- (void)descriptionEditWillUpdate:(FRDescriptionTableViewCell *)editCell;
- (void)descriptionEditDidUpdate:(FRDescriptionTableViewCell *)editCell;

@end

@interface FRDescriptionTableViewCell : FRCommonEditTableViewCell

@property (nonatomic, weak) id<FRDescriptionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *componentImageView;

@end
