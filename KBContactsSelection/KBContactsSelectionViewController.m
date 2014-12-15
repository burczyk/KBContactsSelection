//
//  KBContactsSelectionViewController.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "KBContactsSelectionViewController.h"
#import "KBContactsTableViewDataSource.h"

@interface KBContactsSelectionViewController ()

@property (nonatomic, strong) KBContactsTableViewDataSource *kBContactsTableViewDataSource;

@end

@implementation KBContactsSelectionViewController

static UIColor *tintColor;

- (void)viewDidLoad {
    [super viewDidLoad];

    tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

    _kBContactsTableViewDataSource = [[KBContactsTableViewDataSource alloc] initWithTableView:_tableView];
    _tableView.dataSource = _kBContactsTableViewDataSource;
    _tableView.delegate = _kBContactsTableViewDataSource;
}

+ (UIColor*)tintColor
{
    return tintColor;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_kBContactsTableViewDataSource runSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
