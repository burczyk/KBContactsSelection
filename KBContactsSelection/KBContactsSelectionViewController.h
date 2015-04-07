//
//  KBContactsSelectionViewController.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBContactsSelectionConfiguration.h"
#import "KBContactsTableViewDataSource.h"
#import "APContact+FullName.h"

@class KBContactsSelectionViewController;

@protocol KBContactsSelectionViewControllerDelegate <NSObject>
@optional
- (void) contactsSelectionWillLoadContacts:(KBContactsSelectionViewController *)csvc;
- (void) contactsSelectionDidLoadContacts:(KBContactsSelectionViewController *)csvc;

- (void) contactsSelection:(KBContactsSelectionViewController *)selection didSelectContact:(APContact *)contact;
- (void) contactsSelection:(KBContactsSelectionViewController *)selection didRemoveContact:(APContact *)contact;

// Depracated. Use methods above.
- (void) didSelectContact:(APContact *)contact DEPRECATED_ATTRIBUTE;
- (void) didRemoveContact:(APContact *)contact DEPRECATED_ATTRIBUTE;
@end

@interface KBContactsSelectionViewController : UIViewController
@property (nonatomic, weak) id <KBContactsSelectionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemSelect;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarSearchContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarSearchContactsHeight;

@property (strong, nonatomic) UIView * additionalInfoView;
@property (readonly) NSArray * selectedContacts;

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock;

@end
