//
//  KBContactsSelectionConfiguration.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 16.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KBContactsSelectionConfiguration : NSObject

@property (nonatomic, strong) UIColor *tintColor;

+ (KBContactsSelectionConfiguration*)defaultConfiguration;

@end
