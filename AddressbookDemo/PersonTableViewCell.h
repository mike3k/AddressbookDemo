//
//  PersonTableViewCell.h
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong) IBOutlet UIImageView *personImage;
@property (nonatomic,strong) IBOutlet UIImageView *backgroundImage;
@property (nonatomic,strong) IBOutlet UIVisualEffectView *blurView;
@end
