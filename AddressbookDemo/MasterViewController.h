//
//  MasterViewController.h
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchResultsUpdating>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) UISearchController *searchController;

@end

