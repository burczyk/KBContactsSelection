//
//  APContact+FullName.m
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "APContact+FullName.h"

@implementation APContact (FullName)

- (NSString*)fullName
{
    NSString *result = @"";
    
    if (self.name.firstName) {
        result = self.name.firstName;
    }
    
    if (self.name.lastName) {
        result = [NSString stringWithFormat:@"%@ %@", result, self.name.lastName];
    }
    
    return result;
}

- (NSString*)firstLetterOfFullName
{
    NSString *fullName = [self fullName];
    if (fullName.length > 0) {
        return [[fullName substringToIndex:1] uppercaseString];
    }
    
    return @"";
}

@end
