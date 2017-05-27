//
//  MasterViewController.m
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddressbookDataSource.h"
#import "PersonTableViewCell.h"

@interface MasterViewController ()

@property (nonatomic,strong) AddressbookDataSource *dataSource;
@property (nonatomic,assign) bool loaded;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.dataSource = [[AddressbookDataSource alloc] init];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    if (!self.loaded) {
        [self.dataSource requestAccess:^(bool granted) {
            [self.dataSource loadContacts:^{
                self.loaded = YES;
                [self.tableView reloadData];
            }];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.dataSource.contacts[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.dataSource.contacts[indexPath.row];
    NSData *imageData = object[@"Image"];
    UIImage *image = nil;
    
    cell.nameLabel.text = object[@"Name"];
    cell.phoneLabel.text = [NSString stringWithFormat:@"My Number: %@",object[@"Phone"]];
    
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    } else {
        image = [UIImage imageNamed:@"defaultImage"];
    }
    UIImageView *imageView = cell.personImage;
    CGFloat radius = MIN(CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds)) / 2;
    imageView.layer.cornerRadius = radius;
    imageView.clipsToBounds = YES;
    imageView.image = image;

    cell.backgroundImage.image = image;

    [cell.blurView removeFromSuperview];
    cell.blurView.frame = cell.backgroundImage.bounds;
    [cell.backgroundImage addSubview:cell.blurView];

    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



@end
