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

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
        configuration.tintColor = [UIColor orangeColor];
        configuration.mode = KBContactsSelectionModeEmail;
//        configuration.shouldShowNavigationBar = NO;
    }];
    
    [self presentViewController:vc animated:YES completion:nil];

//    [self.navigationController pushViewController:vc animated:YES];
}


@end
