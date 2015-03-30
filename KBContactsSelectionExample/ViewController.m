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
#import <APAddressBook/APPhoneWithLabel.h>

@interface ViewController () <KBContactsSelectionViewControllerDelegate>

@end

@implementation ViewController

- (IBAction)push:(UIButton *)sender {
    
    __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.shouldShowNavigationBar = NO;
        configuration.tintColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:1];
        configuration.title = @"Push";
        
        configuration.mode = KBContactsSelectionModeMessages | KBContactsSelectionModeEmail;
        configuration.skipUnnamedContacts = YES;
        configuration.customSelectButtonHandler = ^(NSArray * contacts) {
            NSLog(@"%@", contacts);
        };
        configuration.selectionChangedHandler = ^(NSArray * contacts) {
            vc.title = [NSString stringWithFormat:@"%lu contacts", (unsigned long)contacts.count];
        };
        configuration.contactEnabledValidation = ^(id contact) {
            APContact * _c = contact;
            if ([_c phonesWithLabels].count > 0) {
                NSString * phone = ((APPhoneWithLabel*) _c.phonesWithLabels[0]).phone;
                if ([phone containsString:@"888"]) {
                    return NO;
                }
            }
            return YES;
        };
    }];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)present:(UIButton *)sender {
    
    __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.tintColor = [UIColor orangeColor];
        configuration.mode = KBContactsSelectionModeEmail;
        configuration.title = @"Present";
        configuration.customSelectButtonHandler = ^(NSArray * contacts) {
            NSLog(@"%@", contacts);
        };
        configuration.selectionChangedHandler = ^(NSArray * contacts) {
            vc.title = [NSString stringWithFormat:@"%lu contacts", (unsigned long)contacts.count];
        };
    }];
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - KBContactsSelectionViewControllerDelegate
- (void) didSelectContact:(APContact *)contact {
    NSLog(@"Selected contact: %@", [contact fullName]);
}

- (void) didRemoveContact:(APContact *)contact {
    NSLog(@"Removed contact: %@", [contact fullName]);
}

@end
