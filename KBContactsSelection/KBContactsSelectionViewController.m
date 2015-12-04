//
//  KBContactsSelectionViewController.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "KBContactsSelectionViewController.h"



@interface KBContactsSelectionViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, KBContactsTableViewDataSourceDelegate>

@property (strong) NSArray * selectedContacts;

@property (nonatomic, strong) KBContactsTableViewDataSource *kBContactsTableViewDataSource;
@property (nonatomic, strong) KBContactsSelectionConfiguration *configuration;
@property IBOutlet UIView * additionalInfoContainer;
@property IBOutlet NSLayoutConstraint * additionalInfoViewHeightConstraint;
@end

@implementation KBContactsSelectionViewController

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock
{
    KBContactsSelectionViewController *vc = [[self alloc] initWithNibName:@"KBContactsSelectionViewController" bundle:[NSBundle bundleForClass:[KBContactsSelectionViewController class]]];
    
    KBContactsSelectionConfiguration *configuration = [KBContactsSelectionConfiguration defaultConfiguration];
    
    if (configurationBlock) {
        configurationBlock(configuration);
    }
    
    vc.configuration = configuration;

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareContactsDataSource];
    [self prepareNavigationBar];
    [self customizeColors];
    
    [self _showAdditionalInfoViewAnimated:NO];
}

- (void)setAdditionalInfoView:(UIView *)additionalInfoView
{
    if (additionalInfoView != _additionalInfoView) {
        [_additionalInfoView removeFromSuperview];
    }
    _additionalInfoView = additionalInfoView;
    [self _showAdditionalInfoViewAnimated:YES];
}

- (void)_showAdditionalInfoViewAnimated:(BOOL)animated
{
    if (self.additionalInfoView) {
        CGRect r = self.additionalInfoContainer.bounds;
        r.size.height = self.additionalInfoView.frame.size.height;
        
        self.additionalInfoView.frame = r;
        self.additionalInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.additionalInfoContainer addSubview:self.additionalInfoView];
        
        self.additionalInfoViewHeightConstraint.constant = r.size.height;
    } else {
        self.additionalInfoViewHeightConstraint.constant = 0;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutSubviews];
        }];
    } else {
        [self.view layoutSubviews];
    }
}

- (void)prepareContactsDataSource
{
    _kBContactsTableViewDataSource = [[KBContactsTableViewDataSource alloc] initWithTableView:_tableView configuration:_configuration];
    _kBContactsTableViewDataSource.delegate = self;
    _tableView.dataSource = _kBContactsTableViewDataSource;
    _tableView.delegate = _kBContactsTableViewDataSource;
}

- (void)prepareNavigationBar
{
    NSString * selectTitle = (_configuration.selectButtonTitle?:NSLocalizedString(@"Select", nil));
    if (!_configuration.shouldShowNavigationBar) {
        _navigationBarSearchContactsHeight.constant = 0;
        _navigationBarSearchContacts.hidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:selectTitle style:UIBarButtonItemStylePlain target:self action:@selector(buttonSelectPushed:)];
        [self.navigationItem setRightBarButtonItem:bi animated:YES];
        self.buttonItemSelect = bi;
        self.buttonItemSelect.enabled = NO;
    } else {
        self.buttonItemSelect.title = selectTitle;
    }
    [self setTitle:_configuration.title];
}

- (void)setTitle:(NSString *)title
{
    if (!title) {
        title = NSLocalizedString(@"Search contacts", nil);
        _configuration.title = nil;
    } else {
        _configuration.title = title;
    }
    
    [super setTitle:title];
    if (_configuration.shouldShowNavigationBar) {
        self.titleItem.title = title;
    }
}

- (void)customizeColors
{
    _navigationBarSearchContacts.tintColor = _configuration.tintColor;
    self.navigationController.navigationBar.tintColor = _configuration.tintColor;
    _searchBar.tintColor = _configuration.tintColor;
    _tableView.sectionIndexColor = _configuration.tintColor;
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

#pragma mark - IBActions

- (IBAction)buttonCancelPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonSelectPushed:(id)sender {
    if (_configuration.customSelectButtonHandler) {
        _configuration.customSelectButtonHandler([_kBContactsTableViewDataSource selectedContacts]);
    } else {
        if (_configuration.mode & KBContactsSelectionModeMessages) {
            [self showMessagesViewControllerWithSelectedContacts];
        } else {
            [self showEmailViewControllerWithSelectedContacts];
        }
    }
}

- (void)showMessagesViewControllerWithSelectedContacts
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
        messageComposeVC.messageComposeDelegate = self;
        messageComposeVC.recipients = [_kBContactsTableViewDataSource phonesOfSelectedContacts];
        messageComposeVC.body = _configuration.messageBody;
        [self presentViewController:messageComposeVC animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Messaging not supported", @"") message:NSLocalizedString(@"Messaging on this device is not supported.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [alert show];
    }
}

- (void)showEmailViewControllerWithSelectedContacts
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setToRecipients:[_kBContactsTableViewDataSource emailsOfSelectedContacts]];
        [mailComposeVC setMessageBody:_configuration.mailBody isHTML:_configuration.mailIsHTML];
        [mailComposeVC setTitle:_configuration.mailSubject];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Messaging not supported", @"") message:NSLocalizedString(@"Sending emails from this device is not supported.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KBContactsTableViewDataSourceDelegate

- (void)dataSource:(KBContactsTableViewDataSource*)datasource didSelectContact:(APContact *)contact
{
    self.selectedContacts = _kBContactsTableViewDataSource.selectedContacts;
    if ([_delegate respondsToSelector:@selector(contactsSelection:didSelectContact:)]) {
        [_delegate contactsSelection:self didSelectContact:contact];
    } else if ([_delegate respondsToSelector:@selector(didSelectContact:)]) {
        NSLog(@"Using depracated protocol didSelectContact:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        [_delegate didSelectContact:contact];
#pragma clang diagnostic pop
    }
    self.buttonItemSelect.enabled = self.selectedContacts.count > 0;
}

- (void)dataSource:(KBContactsTableViewDataSource*)datasource didRemoveContact:(APContact *)contact
{
    self.selectedContacts = _kBContactsTableViewDataSource.selectedContacts;
    if ([_delegate respondsToSelector:@selector(contactsSelection:didRemoveContact:)]) {
        [_delegate contactsSelection:self didRemoveContact:contact];
    } else if ([_delegate respondsToSelector:@selector(didRemoveContact:)]) {
        NSLog(@"Using depracated protocol didRemoveContact:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        [_delegate didRemoveContact:contact];
#pragma clang diagnostic pop
    }
    self.buttonItemSelect.enabled = self.selectedContacts.count > 0;
}

- (void)dataSourceWillLoadContacts:(KBContactsTableViewDataSource*)datasource
{
    if ([_delegate respondsToSelector:@selector(contactsSelectionWillLoadContacts:)]) {
        [_delegate contactsSelectionWillLoadContacts:self];
    }
}
- (void)dataSourceDidLoadContacts:(KBContactsTableViewDataSource*)datasource
{
    if ([_delegate respondsToSelector:@selector(contactsSelectionDidLoadContacts:)]) {
        [_delegate contactsSelectionDidLoadContacts:self];
    }
}

@end
