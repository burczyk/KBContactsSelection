//
//  KBContactCell.h
//  KBContactsSelectionExample
//
//  Created by Kamil Burczyk on 13.12.2014.
//  Copyright (c) 2014 Sigmapoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBRadioButton.h"

@interface KBContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneType;
@property (weak, nonatomic) IBOutlet KBRadioButton *buttonSelection;

@end
