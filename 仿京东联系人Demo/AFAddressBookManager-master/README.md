AFAddressBookManager
====================
![Pod version](http://img.shields.io/cocoapods/v/AFAddressBookManager.svg?style=flat)
![Pod platform](http://img.shields.io/cocoapods/p/AFAddressBookManager.svg?style=flat)
[![Build Status](https://travis-ci.org/Fogh/AFAddressBookManager.svg?branch=master)](https://travis-ci.org/Fogh/AFAddressBookManager)

Get contacts from iOS Address Book by their phone numbers and email addresses. Works on iOS 6+.

*If you are developing for iOS 9 and above you should definitely be using the [**Contacts framework**](https://developer.apple.com/library/prerelease/mac/documentation/Contacts/Reference/Contacts_Framework/index.html#//apple_ref/doc/uid/TP40015328) instead.*

## Installation

### [CocoaPods](http://cocoapods.org)

```ruby
platform :ios, '6.0'
pod 'AFAddressBookManager', '~> 1.2'
```

### Manually

Copy all files from AFAddressBookManager folder to your project and add the [Address Book framework](http://developer.apple.com/library/ios/#documentation/AddressBook/Reference/AddressBook_iPhoneOS_Framework/).

## Usage

Import `AFAddressBookManager.h` in the class where you want to use it.

### Available methods

Get name (first and last) of contact by phone number:
```objectivec
+ (NSString *)nameForContactWithPhoneNumber:(NSString *)phoneNumber;
```

Get photo of contact by phone number:
```objectivec 
+ (UIImage *)photoForContactWithPhoneNumber:(NSString *)phoneNumber;
```

Get name (first and last) of contact by email address:
```objectivec
+ (NSString *)nameForContactWithEmailAddress:(NSString *)emailAddress;
```

Get photo of contact by email address:
```objectivec 
+ (UIImage *)photoForContactWithEmailAddress:(NSString *)emailAddress;
```


## Other iOS Open Source Projects by Me

- [AFWebViewController](https://github.com/Fogh/AFWebViewController)
- [AFMobilePayRequestHandler](https://github.com/Fogh/AFMobilePayRequestHandler)


---

<a href="http://Fogh.tip.me">
  <img
    alt="Tip Me With ChangeTip"
    src="https://cdn.changetip.com/img/logos/tipme_square.png?1"/>
</a>
