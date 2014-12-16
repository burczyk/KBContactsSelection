//
//  KBContactsSelectionConfiguration.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 16.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "KBContactsSelectionConfiguration.h"

@implementation KBContactsSelectionConfiguration

+ (KBContactsSelectionConfiguration*)defaultConfiguration
{
    KBContactsSelectionConfiguration *configuration = [[KBContactsSelectionConfiguration alloc] init];
    
    configuration.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    return configuration;
}

@end
