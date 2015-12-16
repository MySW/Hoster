//
//  TapyTableViewCell.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "TapyTableViewCell.h"

#define CellHeight  self.frame.size.height
#define CellWidth   self.frame.size.width
#define LineX       5
#define LINEMIDX    2

@implementation TapyTableViewCell

- (void)awakeFromNib
{
//    self.iconImageView.frame = CGRectMake(LineX, CellHeight * 0.1, CellHeight *0.8, CellHeight * 0.8);
//    self.iconImageView.center = CGPointMake(LineX + CGRectGetWidth(self.iconImageView.frame) / 2, CellHeight / 2);
//    NSLog(@"%f", CellHeight/2);
//    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + LINEMIDX, CGRectGetMinY(self.iconImageView.frame), CellWidth/3, CGRectGetHeight(self.iconImageView.frame));
//    self.titleLabel.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + CGRectGetWidth(self.titleLabel.frame) / 2, CellHeight / 2);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
