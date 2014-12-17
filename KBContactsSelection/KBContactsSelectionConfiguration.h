//
//  KBContactsSelectionConfiguration.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 16.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KBContactsSelectionMode) {
    KBContactsSelectionModeMessages,
    KBContactsSelectionModeEmail
};

@interface KBContactsSelectionConfiguration : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) KBContactsSelectionMode mode;
@property (nonatomic, assign) BOOL shouldShowNavigationBar;

+ (KBContactsSelectionConfiguration*)defaultConfiguration;

@end
