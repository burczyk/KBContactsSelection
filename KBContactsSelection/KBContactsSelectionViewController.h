//
//  KBContactsSelectionViewController.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBContactsSelectionConfiguration.h"

typedef void(^KBContactSelectionHandler)(NSArray * selectedContacts);

@interface KBContactsSelectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemSelect;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarSearchContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarSearchContactsHeight;

@property (strong) KBContactSelectionHandler customSelectionHandler;

+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock;

@end
