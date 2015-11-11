//
//  ViewController.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "ViewController.h"
#import "KBContactsSelectionViewController.h"
#import <APAddressBook/APContact.h>
#import <SVProgressHUD.h>

@interface ViewController () <KBContactsSelectionViewControllerDelegate>
@property (weak) KBContactsSelectionViewController* presentedCSVC;
@end

@implementation ViewController

- (IBAction)push:(UIButton *)sender {
    
    __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.shouldShowNavigationBar = NO;
        configuration.tintColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:1];
        configuration.title = @"Push";
        configuration.selectButtonTitle = @"+";
        
        configuration.mode = KBContactsSelectionModeMessages | KBContactsSelectionModeEmail;
        configuration.skipUnnamedContacts = YES;
        configuration.customSelectButtonHandler = ^(NSArray * contacts) {
            NSLog(@"%@", contacts);
        };
        configuration.contactEnabledValidation = ^(id contact) {
            APContact * _c = contact;
            if ([_c phones].count > 0) {
                NSString * phone = ((APPhone*) _c.phones[0]).number;
                if ([phone containsString:@"888"]) {
                    return NO;
                }
            }
            return YES;
        };
    }];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    self.presentedCSVC = vc;
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Select people you want to text";

    vc.additionalInfoView = label;
}

- (IBAction)present:(UIButton *)sender {
    
    __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.tintColor = [UIColor orangeColor];
        configuration.mode = KBContactsSelectionModeEmail;
        configuration.title = @"Present";
        configuration.selectButtonTitle = @"Invite";
        configuration.customSelectButtonHandler = ^(NSArray * contacts) {
            NSLog(@"%@", contacts);
        };
        
        configuration.searchByKeywords = YES;
        
    }];
    
    
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    self.presentedCSVC = vc;
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Select people you want to email";
    
    vc.additionalInfoView = label;
}

#pragma mark - KBContactsSelectionViewControllerDelegate
- (void) contactsSelection:(KBContactsSelectionViewController*)selection didSelectContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@ Selected", @(self.presentedCSVC.selectedContacts.count)];
    
    self.presentedCSVC.additionalInfoView = label;
    
    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

- (void) contactsSelection:(KBContactsSelectionViewController*)selection didRemoveContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@ Selected", @(self.presentedCSVC.selectedContacts.count)];
    
    self.presentedCSVC.additionalInfoView = label;
    
    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

- (void)contactsSelectionWillLoadContacts:(KBContactsSelectionViewController *)csvc
{
    [SVProgressHUD showWithStatus:@"Loading..."];
}
- (void)contactsSelectionDidLoadContacts:(KBContactsSelectionViewController *)csvc
{
    [SVProgressHUD dismiss];
}
@end
