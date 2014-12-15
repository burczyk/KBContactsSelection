//
//  APContact+FullName.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import "APContact.h"

@interface APContact (FullName)

- (NSString*)fullName;

- (NSString*)firstLetterOfFullName;

@end
