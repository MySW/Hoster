//
//  AddressCell.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "AddressCell.h"

#define CellHeight  self.frame.size.height
#define CellWidth   self.frame.size.width
#define LineX       5

@implementation AddressCell 

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    self.iconImageView.frame = CGRectMake(LineX, CellHeight *0.1, CellHeight * 0.8, CellHeight * 0.8);
    self.iconImageView.center = CGPointMake(CGRectGetWidth(self.iconImageView.frame)/ 2 + LineX, CellHeight/2);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 2, CGRectGetMinY(self.iconImageView.frame), CellWidth - LineX - CGRectGetMaxX(self.iconImageView.frame) - 2, CGRectGetHeight(self.iconImageView.frame) * 0.6);
    self.titleLabel.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + CGRectGetWidth(self.titleLabel.frame) / 2  , CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame) / 2);
    
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.iconImageView.frame)*0.4);
    self.detailLabel.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + CGRectGetWidth(self.titleLabel.frame) / 2, CGRectGetMinY(self.detailLabel.frame) + CGRectGetHeight(self.detailLabel.frame) / 2);
    
    self.placeholderLabel.frame = CGRectMake(CGRectGetMidX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.iconImageView.frame));
    self.placeholderLabel.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + CGRectGetWidth(self.titleLabel.frame) / 2, CellHeight / 2);
}

@end
