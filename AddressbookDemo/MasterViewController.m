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
@property (nonatomic,strong) NSArray *filteredContacts;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.dataSource = [[AddressbookDataSource alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;

}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    // load contacts the first time the view appears
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

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *search = [NSPredicate predicateWithFormat:@"Name CONTAINS[c] %@",searchController.searchBar.text];
    self.filteredContacts = [self.dataSource.contacts filteredArrayUsingPredicate:search];
    [self.tableView reloadData];
}

// convenience method to return appropriate data source depending on whether search is active
- (NSArray*)contacts {
    if (self.searchController.active) {
        return self.filteredContacts;
    } else {
        return self.dataSource.contacts;
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.contacts[indexPath.row];
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
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.contacts[indexPath.row];
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
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",
             @"J",@"K",@"L",@"M",@"N",@"O",@"P",
             @"Q",@"R",@"S",@"T",@"U",@"V",@"W",
             @"X",@"Y",@"Z"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    
    // don't scroll if search is active
    if (self.searchController.active) {
        return -1;
    }
    
    if ([title isEqualToString:@"#"]) { // special case
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                             inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSNumber *value = [self.dataSource.index objectForKey:title];
    if (nil != value) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:value.integerValue
                                                             inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   }
    return -1;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



@end
