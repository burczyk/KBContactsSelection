//
//  KBContactsTableViewDataSource.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KBContactsSelectionConfiguration.h"

#import "APAddressBook.h"

@class KBContactsTableViewDataSource;

@protocol KBContactsTableViewDataSourceDelegate <NSObject>
- (void)dataSource:(KBContactsTableViewDataSource*)datasource didSelectContact:(APContact *)contact;
- (void)dataSource:(KBContactsTableViewDataSource*)datasource didRemoveContact:(APContact *)contact;
- (void)dataSourceWillLoadContacts:(KBContactsTableViewDataSource*)datasource;
- (void)dataSourceDidLoadContacts:(KBContactsTableViewDataSource*)datasource;
@end


@interface KBContactsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <KBContactsTableViewDataSourceDelegate> delegate;
@property (nonatomic, strong) NSArray *contacts;

- (instancetype)initWithTableView:(UITableView*)tableView configuration:(KBContactsSelectionConfiguration*)configuration;

- (void)runSearch:(NSString*)text;
- (void)selectAll;
- (void)removeAll;
- (NSArray*)selectedContacts;
- (NSArray*)phonesOfSelectedContacts;
- (NSArray*)emailsOfSelectedContacts;

@end
