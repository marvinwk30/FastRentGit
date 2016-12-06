//
//  FRProfileMenuTableViewCell.h
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 7/28/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRAccountImageView.h"

@interface FRProfileMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FRAccountImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@end
