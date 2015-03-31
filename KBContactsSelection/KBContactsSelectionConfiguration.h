//
//  KBContactsSelectionConfiguration.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 16.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KBContactSelectionHandler)(NSArray * selectedContacts);
typedef BOOL(^KBContactValidation)(id contact);

typedef NS_ENUM(NSInteger, KBContactsSelectionMode) {
    KBContactsSelectionModeMessages     = 1 << 0,
    KBContactsSelectionModeEmail        = 1 << 1
};

@interface KBContactsSelectionConfiguration : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) BOOL shouldShowNavigationBar;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign) enum KBContactsSelectionMode mode;
@property (nonatomic, assign) BOOL skipUnnamedContacts;

@property (strong) NSString * selectButtonTitle;
@property (strong) KBContactSelectionHandler customSelectButtonHandler;
@property (strong) KBContactValidation contactEnabledValidation;

+ (KBContactsSelectionConfiguration*)defaultConfiguration;

@end
