//
//  INAccordionHeader.h
//  Inmobile
//
//  Created by Marvin Avila Kotliarov on 12/18/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRDateHeader : UIButton

@property (weak, nonatomic) IBOutlet UIImageView *disclosureImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disclosureWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disclosureHeight;
@property (weak, nonatomic) IBOutlet UILabel *totalSelectedLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalSelectedLblWidth;

@end
