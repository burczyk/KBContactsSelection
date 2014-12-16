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

@interface KBContactsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithTableView:(UITableView*)tableView configuration:(KBContactsSelectionConfiguration*)configuration;

- (void)runSearch:(NSString*)text;

- (NSArray*)selectedContacts;
- (NSArray*)phonesOfSelectedContacts;
- (NSArray*)emailsOfSelectedContacts;

@end
