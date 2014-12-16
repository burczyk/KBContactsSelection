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
@property (nonatomic, strong) KBContactsSelectionConfiguration *kBContactsSelectionConfiguration;

@end

@implementation KBContactsSelectionViewController

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock
{
    KBContactsSelectionViewController *vc = [[KBContactsSelectionViewController alloc] initWithNibName:@"KBContactsSelectionViewController" bundle:nil];
    
    KBContactsSelectionConfiguration *configuration = [KBContactsSelectionConfiguration defaultConfiguration];
    configurationBlock(configuration);
    vc.kBContactsSelectionConfiguration = configuration;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _kBContactsTableViewDataSource = [[KBContactsTableViewDataSource alloc] initWithTableView:_tableView configuration:_kBContactsSelectionConfiguration];
    _tableView.dataSource = _kBContactsTableViewDataSource;
    _tableView.delegate = _kBContactsTableViewDataSource;
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
