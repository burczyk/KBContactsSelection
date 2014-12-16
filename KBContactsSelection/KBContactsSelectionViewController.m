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
@property (nonatomic, strong) KBContactsSelectionConfiguration *configuration;

@end

@implementation KBContactsSelectionViewController

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock
{
    KBContactsSelectionViewController *vc = [[KBContactsSelectionViewController alloc] initWithNibName:@"KBContactsSelectionViewController" bundle:nil];
    
    KBContactsSelectionConfiguration *configuration = [KBContactsSelectionConfiguration defaultConfiguration];
    configurationBlock(configuration);
    vc.configuration = configuration;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _kBContactsTableViewDataSource = [[KBContactsTableViewDataSource alloc] initWithTableView:_tableView configuration:_configuration];
    _tableView.dataSource = _kBContactsTableViewDataSource;
    _tableView.delegate = _kBContactsTableViewDataSource;
    
    _tableView.sectionIndexColor = _configuration.tintColor;
    _searchBar.tintColor = _configuration.tintColor;
    
    [self customizeColors];
}

- (void)customizeColors
{
    _buttonItemCancel.tintColor = _configuration.tintColor;
    _buttonItemSelect.tintColor = _configuration.tintColor;
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
