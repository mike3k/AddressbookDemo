//
//  PersonTableViewCell.m
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.blurView.clipsToBounds = YES;
    self.blurView.frame = self.backgroundImage.bounds;
    [self.backgroundImage addSubview:self.blurView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.blurView.frame = self.backgroundImage.bounds;
}

@end
