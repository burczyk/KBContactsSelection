//
//  KBContactsSelectionConfiguration.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 16.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KBContactsSelectionDestination) {
    KBContactsSelectionDestinationMessages,
    KBContactsSelectionDestinationEmail
};

@interface KBContactsSelectionConfiguration : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) KBContactsSelectionDestination destination;

+ (KBContactsSelectionConfiguration*)defaultConfiguration;

@end
