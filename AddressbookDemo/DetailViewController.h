//
//  DetailViewController.h
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

