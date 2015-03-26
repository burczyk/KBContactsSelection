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


@protocol KBContactsSelectionViewControllerDelegate <NSObject>
@optional
- (void) didSelectContact:(APContact *)contact;
- (void) didRemoveContact:(APContact *)contact;
@end

@interface KBContactsSelectionViewController : UIViewController
@property (nonatomic, weak) id <KBContactsSelectionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemSelect;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarSearchContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarSearchContactsHeight;

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock;

@end
