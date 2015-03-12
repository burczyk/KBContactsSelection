//
//  ViewController.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "ViewController.h"
#import "KBContactsSelectionViewController.h"

@interface ViewController ()

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
    }];

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

    [self presentViewController:vc animated:YES completion:nil];
}

@end
