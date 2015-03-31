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
@property UILabel * additionalInfoLabel;
@property (weak) KBContactsSelectionViewController* presentedCSVC;
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
    self.presentedCSVC = vc;
}

- (IBAction)present:(UIButton *)sender {
    
    __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.tintColor = [UIColor orangeColor];
        configuration.mode = KBContactsSelectionModeEmail;
        configuration.title = @"Present";
        configuration.customSelectButtonHandler = ^(NSArray * contacts) {
            NSLog(@"%@", contacts);
        };
    }];
    
    
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    self.presentedCSVC = vc;
}

#pragma mark - KBContactsSelectionViewControllerDelegate
- (void) didSelectContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"Selected contact: %@", [contact fullName]];
    [label sizeToFit];
    
    self.additionalInfoLabel = label;
    self.presentedCSVC.additionalInfoView = self.additionalInfoLabel;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.presentedCSVC.additionalInfoView == label) {
            self.presentedCSVC.additionalInfoView = nil;
        }
    });
    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

- (void) didRemoveContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"Removed contact: %@", [contact fullName]];
    [label sizeToFit];
    
    self.additionalInfoLabel = label;
    self.presentedCSVC.additionalInfoView = self.additionalInfoLabel;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.presentedCSVC.additionalInfoView == label) {
            self.presentedCSVC.additionalInfoView = nil;
        }
    });
    
    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

@end
