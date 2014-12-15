//
//  KBContactsTableViewDataSource.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "KBContactsTableViewDataSource.h"
#import "KBContactCell.h"
#import "APAddressBook.h"
#import "APContact+FullName.h"
#import "APPhoneWithLabel.h"

@interface KBContactsTableViewDataSource()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *unmodifiedContacts;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContactsRecordIds;
@property (nonatomic, strong) NSMutableArray *selectedRows;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableDictionary *contactsGroupedInSections;

@end

@implementation KBContactsTableViewDataSource

static NSString *cellIdentifier = @"KBContactCell";

- (instancetype)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        [_tableView registerNib:[UINib nibWithNibName:@"KBContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        
        [self initializeArrays];
        [self loadContacts];
    }
    return self;
}

- (void)initializeArrays
{
    _unmodifiedContacts = [NSArray array];
    _contacts = [NSArray array];
    _selectedContactsRecordIds = [NSMutableArray array];
    _sectionIndexTitles = [NSArray array];
    _contactsGroupedInSections = [NSMutableDictionary dictionary];
}

- (void)loadContacts
{
    APAddressBook *ab = [[APAddressBook alloc] init];
    ab.fieldsMask = APContactFieldFirstName | APContactFieldLastName | APContactFieldPhonesWithLabels | APContactFieldRecordID;
    ab.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    ab.filterBlock = ^BOOL(APContact *contact){
        return contact.phonesWithLabels.count > 0;
    };
    
    [ab loadContacts:^(NSArray *contacts, NSError *error) {
        if (contacts) {
            NSArray *filteredContacts = [self filteredDuplicatedContacts:contacts];
            self.unmodifiedContacts = filteredContacts;
            self.contacts = filteredContacts;
        }
        [self updateAfterModifyingContacts];
    }];
}

//This method filters duplicated contacts by full name and phone.
//Duplicated contacts occur when device synchronizes contacts with more than one cloud: e.g. iCloud and google.
- (NSArray*)filteredDuplicatedContacts:(NSArray*)contacts
{
    NSMutableArray *filteredContacts = [NSMutableArray array];
    
    for (APContact *contact in contacts) {
        if (![self contactsArray:filteredContacts containsContact:contact]) {
            [filteredContacts addObject:contact];
        }
    }
    
    return filteredContacts;
}

- (BOOL)contactsArray:(NSArray*)array containsContact:(APContact*)searchedContact
{
    NSString *searchedContactFullName = [searchedContact fullName];
    NSString *searchedContactPhone = ((APPhoneWithLabel*) searchedContact.phonesWithLabels[0]).phone;
    
    for (APContact *contact in array) {
        BOOL fullNamesEqual = [[contact fullName] isEqualToString:searchedContactFullName];
        BOOL phonesEqual = [((APPhoneWithLabel*) contact.phonesWithLabels[0]).phone isEqualToString:searchedContactPhone];
        
        if (fullNamesEqual && phonesEqual) {
            return YES;
        }
    }
    
    return NO;
}

- (void)updateAfterModifyingContacts
{
    [self groupContacts];
    [self prepareInitials];
    
    [_tableView reloadData];
    _tableView.tableHeaderView = nil;
}

- (void)groupContacts
{
    _contactsGroupedInSections = [NSMutableDictionary dictionary];
    
    for (APContact *contact in _contacts) {
        NSString *firstLetter = [contact firstLetterOfFullName];
        NSMutableArray *contactsForFirstLetter = _contactsGroupedInSections[firstLetter] ?: [NSMutableArray array];
        [contactsForFirstLetter addObject:contact];
        _contactsGroupedInSections[firstLetter] = contactsForFirstLetter;
    }
}

- (void)prepareInitials
{
    NSMutableSet *contactsInitialsSet = [NSMutableSet set];
    [_contacts enumerateObjectsUsingBlock:^(APContact *contact, NSUInteger idx, BOOL *stop) {
        [contactsInitialsSet addObject:[contact firstLetterOfFullName]];
    }];
    _sectionIndexTitles = [[contactsInitialsSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString *s1, NSString *s2) {
        return [s1 compare:s2];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionIndexTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionIndexTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = _sectionIndexTitles[section];
    NSArray *contacts = _contactsGroupedInSections[sectionTitle];
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBContactCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    APContact *contact = [self contactAtIndexPath:indexPath];
    if (contact) {
        cell.labelName.text = [contact fullName];
        
        APPhoneWithLabel *phoneWithLabel = contact.phonesWithLabels[0];
        if (phoneWithLabel) {
            cell.labelPhone.text = phoneWithLabel.phone;
            cell.labelPhoneType.text = phoneWithLabel.label;
        }
        
        cell.buttonSelection.selected = [_selectedContactsRecordIds containsObject:contact.recordID];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBContactCell *cell = (KBContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonSelection.selected = !cell.buttonSelection.selected;
    
    APContact *contact = [self contactAtIndexPath:indexPath];
    if (contact) {
        BOOL selected = [_selectedContactsRecordIds containsObject:contact.recordID];
        if (selected) {
            [_selectedContactsRecordIds removeObject:contact.recordID];
        } else {
            [_selectedContactsRecordIds addObject:contact.recordID];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBContactCell *cell = (KBContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonSelection.highlighted = YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBContactCell *cell = (KBContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonSelection.highlighted = NO;
}

#pragma mark - Search

- (void)runSearch:(NSString*)text
{
    if (text.length == 0) {
        _contacts = _unmodifiedContacts;
    } else {
        NSMutableArray *filteredContacts = [NSMutableArray array];
        [_unmodifiedContacts enumerateObjectsUsingBlock:^(APContact *contact, NSUInteger idx, BOOL *stop) {
            if ([[contact fullName] rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [filteredContacts addObject:contact];
            }
        }];
        _contacts = filteredContacts;
    }
    [self updateAfterModifyingContacts];
}

#pragma mark - Helpers

- (APContact*)contactAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section < _contactsGroupedInSections.count) {
        NSArray *contactsInSection = _contactsGroupedInSections[_sectionIndexTitles[indexPath.section]];
        if (indexPath.row < contactsInSection.count) {
            return contactsInSection[indexPath.row];
        }
    }
    return nil;
}

@end
