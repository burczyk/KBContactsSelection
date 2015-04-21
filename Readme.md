#KBContactsSelection
**KBContactsSelection** is a standalone UI and logic component that allows you to easily search and select contacts in your Address Book and redirect to Mail or Messages with results.

##Showcase
Notice elegant solution with phone number, emails and final redirect difference.

![KBContactsSelection screen 1](https://raw.githubusercontent.com/burczyk/KBContactsSelection/master/assets/KBContactsSelection.png)

![KBContactsSelection gif](https://raw.githubusercontent.com/burczyk/KBContactsSelection/master/assets/KBContactsSelection.gif)

##Installation
**KBContactsSelection** is available via [CocoaPods](http://cocoapods.org). To use it simply add one line to your Podfile:

```
pod 'KBContactsSelection'
```

and then add required `import`:

```objective-c
#import "KBContactsSelectionViewController.h"
```

##Configuration
The public element of library is `KBContactsSelectionViewController` class. It contains one convenient method to create instance of itself with proper configuration:

```objective-c
+ (KBContactsSelectionViewController*)contactsSelectionViewControllerWithConfiguration:(void (^)(KBContactsSelectionConfiguration* configuration))configurationBlock;
```

**The simplest possible usage** looks like this:

```objective-c
KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:nil];

[self presentViewController:vc animated:YES completion:nil];
```


It uses objective-c [Builder Pattern](http://en.wikipedia.org/wiki/Builder_pattern) adopted in elegant way with blocks usage. Inpiration for such solution was found [here](http://joris.kluivers.nl/blog/2014/04/08/the-builder-pattern-in-objective-c-foundation/).

`KBContactsSelectionViewController` is fullscreen view controller and it can be either pushed on navigation stack or presented.

`KBContactsSelectionConfiguration` class is responsinble for setting both basic and advanced properties:

**Look & Feel**

```objective-c
UIColor *tintColor;
BOOL shouldShowNavigationBar;
NSString * title;
```

**Contacts' behavior**

```objective-c
enum KBContactsSelectionMode mode;
BOOL skipUnnamedContacts;
KBContactValidation contactEnabledValidation;
```

**Customizable Action**

```objective-c
NSString * selectButtonTitle;
KBContactSelectionHandler customSelectButtonHandler;
```

**Define Text/E-mail**

```objective-c
configuration.mailBody = @"Some mail body";
configuration.mailIsHTML = false;
configuration.mailSubject = @"Important Subject";
configuration.messageBody = @"This is text content";
```

**tintColor** is responsible for setting navigation bar `tintColor`, table view `sectionIndexColor` and search bar `tintColor`.

**shouldShowNavigationBar** hides navigation bar from `KBContactsSelectionViewController` and should set when you push this view controller instead of presenting it.

**title** can be set before displaying the controller. It will set the `title` of the `navigationBar`.

**mode** can be set to mask either one or two values: `KBContactsSelectionModeMessages` and/or `KBContactsSelectionModeEmail`. They have impact on data displayed (emails or phone numbers) and final navigation (Messages or Mail app) for selected contacts. In order to display contacts with either an email or phone numbers (or both), you can set this variable to the combined mask `KBContactsSelectionModeMessages | KBContactsSelectionModeEmail` 

**skipUnnamedContacts** automatically will filter out all contacts without a First or Last name set.

**searchByKeywords** will allow to search for names using keywords (Searching for 'f b' would filter 'Felipe Baytelman' and 'Bruno Finstein').

**contactEnabledValidation** can be used to manually enable/disable contacts in the list, using a custom block ```BOOL(^KBContactValidation)(APContact * contact)```. When defined, this block will be called for each contact.

**selectButtonTitle** let's you customize the `text` of the Select button. Using default `nil` will display a localized version of Select.

**customSelectButtonHandler** allows to call a custom action (block) on the selected contacts when the users taps the Select button. By default, when this value is `nil`, an email composer will be prompted or a SMS message composer will be presented (depending on selected `mode`). If `customSelectButtonHandler` is defined (`void(^KBContactSelectionHandler)(NSArray * selectedContacts)`), it will be invoked with an `NSArray` of `APContact` objects. 

##Usage
###Pushing KBContactsSelectionViewController with phone numbers

```objective-c
KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
    configuration.mode = KBContactsSelectionModeMessages;
    configuration.shouldShowNavigationBar = NO;
    configuration.tintColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:1];
}];

[self.navigationController pushViewController:vc animated:YES];
```

###Presenting KBContactsSelectionViewController with emails

```objective-c
KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
    configuration.tintColor = [UIColor orangeColor];
    configuration.mode = KBContactsSelectionModeEmail;
}];

[self presentViewController:vc animated:YES completion:nil];
```

###Enabling specific contacts and customizing select action

This example will enable those rows corresponding to contacts with photos.

```objective-c
KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
    configuration.tintColor = [UIColor orangeColor];
    configuration.mode = KBContactsSelectionModeEmail;
    configuration.skipUnnamedContacts = YES;
    configuration.contactEnabledValidation = ^BOOL(APContact * contact) {
    	return contact.photo != nil;
    };
}];

[self presentViewController:vc animated:YES completion:nil];
```

Each property of `KBContactsSelectionConfiguration` can be freely modified although it is advised not to hide navigation bar when presented and hide it when pushed.

##Example project
Example project is attached to this repository. Open `KBContactsSelectionExample.xcworkspace`, install all required dependencies by performing `pod install` and run the the same demo as in gif above.

##Known issues
iOS Simulator obviously doesn't support messaging (proper alert) and apparently has some issues with presenting `MFMailComposeViewController`:

```
KBContactsSelectionExample[20027:5171733] _serviceViewControllerReady:error: Error Domain=_UIViewServiceErrorDomain Code=1 "The operation couldn’t be completed. (_UIViewServiceErrorDomain error 1.)" UserInfo=0x7f95cae243f0 {Canceled=service continuation}
```

It works fine on real device but fails on Simulator which is probably a bug. Some StackOverflow threads regarding this issue can be found [here](http://stackoverflow.com/questions/25604552/i-have-real-misunderstanding-with-mfmailcomposeviewcontroller-in-swift-ios8-in) and [here](http://stackoverflow.com/questions/25604552/i-have-real-misunderstanding-with-mfmailcomposeviewcontroller-in-swift-ios8-in).

This is why presented email view controller in gif doesn't have recipients entered.

##Components
###KBContactsSelectionViewController
Is a main component of whole library and probably the only one you should explicitly use. For a convenience it has some self-describing public properties to tweak its behavior:

```objective-c
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItemSelect;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarSearchContacts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarSearchContactsHeight;
```

It is responsible for most of user interactions: buttons, presenting final view controllers, search. 

**Additional Info View**

In cases when you need to add a prompt or selection summary, `additionalInfoView` property allows to dynamically add such a view:

```objective-c
@property (strong, nonatomic) UIView * additionalInfoView;
```
The `additionalInfoView`` will be included between the navigation bar and the search bar. It will persist even during search, allowing you to present relevant information to the user. Additional info views can be set prior or after presenting the view controller. This is shown in the attached example project.

This view will be stretched horizontally to fill the width of the table view. Vertically, the view controller will consider the additional view's height and push down the search bar in order to fit it correctly. If `additionalInfoView` is set after the view controller is presented, the search bar will be pushed down with an animation. 

The following example displays a label providing context or instructions to the user:

```objective-c
KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
		configuration.title = @"New Project";
		...
    };
}];

UILabel * instructionsLabel = [[UILabel alloc] init];
instructionsLabel.text = @"Add new participants to the new project"; 
vc.additionalInfoView = instructionsLabel;
```

**Data Source**

Despite the fact that `KBContactsSelectionViewController` contains table view it doesn't act as its data source or delegate. It passes all responsibilities regarding table view to `KBContactsTableViewDataSource` component.

###KBContactsTableViewDataSource
Is an object that adopts two protocols: `<UITableViewDataSource, UITableViewDelegate>` and is fully responsible for rendering, filtering and capturing contacts in table view.

It starts with loading all contacts once and storing them in immutable array for performance reasons. Then it groups the contacts in a dictionary where keys are first letters of full name and values are sorted arrays of all contacts whose name starts with this letter.

Search is performed by creating a filtered copy of all contacts and grouping it like before.

All selected contacts are stored in separate array by `recordID` field so they are persisted between searches.

When `Select` button is pushed initial contacts array is filtered using all `recordIds` and proper view controller is displayed.

###KBContactsSelectionConfiguration
Was described in **Configuration** section.

###KBContactsSelectionViewControllerDelegate
Cotains two methods:

```objective-c
- (void) didSelectContact:(APContact *)contact;
- (void) didRemoveContact:(APContact *)contact;
```

that can be used to observe contacts modification. Thanks to @benaneesh.

##Localized strings
Library contains `NSLocalizedString` macro in proper places so you can generate `Localizable.strings` file with following literals:

```
"Messaging not supported" = "Messaging not supported";
"Messaging on this device is not supported." = "Messaging on this device is not supported.";
"OK" = "OK";
"Search contacts" = "Search contacts";
"Select" = "Select";
"Sending emails from this device is not supported." = "Sending emails from this device is not supported.";
```

##Dependencies
**KBContactsSelection** uses [APAddressBook](https://github.com/Alterplay/APAddressBook) to easily manage iOS Address Book.

##License
**KBContactsSelection** is under `MIT License`. See [LICENSE](https://github.com/burczyk/KBContactsSelection/blob/master/LICENSE) file for more info.
