//
//  DetailViewController.m
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.nameLabel.text = [self.detailItem valueForKey:@"Name"];
        self.phoneLabel.text = [self.detailItem valueForKey:@"Phone"];
        
        NSData *imageData = [self.detailItem valueForKey:@"Image"];
        UIImage *image = nil;
        
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        } else {
            image = [UIImage imageNamed:@"defaultImage"];
        }
        self.imageView.image = image;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
