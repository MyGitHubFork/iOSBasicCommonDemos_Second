/*
     File: QuickContactsViewController.m
 Abstract: Demonstrates how to use ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate,
 ABNewPersonViewControllerDelegate, and ABUnknownPersonViewControllerDelegate. Shows how to browse a list of 
 Address Book contacts, display and edit a contact record, create a new contact record, and update a partial contact record.
  Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
*/

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "QuickContactsViewController.h"

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

enum TableRowSelected
{
	kUIDisplayPickerRow = 0,
	kUICreateNewContactRow,
	kUIDisplayContactRow,
	kUIEditUnknownContactRow
};

// Height for the Edit Unknown Contact row
#define kUIEditUnknownContactRowHeight 81.0

@interface QuickContactsViewController () < ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,
                                            ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation QuickContactsViewController

#pragma mark Load views
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
    // Create an address book object
	_addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    self.menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self checkAddressBookAccess];
}

#pragma mark -
#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
        // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    QuickContactsViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
    {
        if (granted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf accessGrantedForAddressBook];
                                                         
            });
        }
    });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{
    // Load data from the plist file
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
	self.menuArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [self.tableView reloadData];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.menuArray count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"CellID";
    UITableViewCell *aCell;
	// Make the Display Picker and Create New Contact rows look like buttons
    if (indexPath.section < 2)
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        aCell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aCell.detailTextLabel.numberOfLines = 0;
        // Display descriptions for the Edit Unknown Contact and Display and Edit Contact rows
        aCell.detailTextLabel.text = [[self.menuArray objectAtIndex:indexPath.section] valueForKey:@"description"];
    }
	aCell.textLabel.text = [[self.menuArray objectAtIndex:indexPath.section] valueForKey:@"title"];
	return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case kUIDisplayPickerRow:
			[self showPeoplePickerController];
			break;
		case kUICreateNewContactRow:
			[self showNewPersonViewController];
			break;
		case kUIDisplayContactRow:
			[self showPersonViewController];
			break;
		case kUIEditUnknownContactRow:
			[self showUnknownPersonViewController];
			break;
		default:
			[self showPeoplePickerController];
			break;
	}	
}

#pragma mark TableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Change the height if Edit Unknown Contact is the row selected
	return (indexPath.section==kUIEditUnknownContactRow) ? kUIEditUnknownContactRowHeight : tableView.rowHeight;	
}

#pragma mark Show all contacts
// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							    //[NSNumber numberWithInt:kABPersonEmailProperty],
							    [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
    if (IOS_VERSION >= 8) {//iOS8以上需要这句话，不然直接退出
        picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
	picker.displayedProperties = displayedItems;
	// Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark Display and edit a person
// Called when users tap "Display and Edit Contact" in the application. Searches for a contact named "Appleseed" in 
// in the address book. Displays and allows editing of all information associated with that contact if
// the search is successful. Shows an alert, otherwise.
-(void)showPersonViewController
{
	// Search for the person named "Appleseed" in the address book
	NSArray *people = (NSArray *)CFBridgingRelease(ABAddressBookCopyPeopleWithName(self.addressBook, CFSTR("黄")));
	// Display "Appleseed" information if found in the address book 
	if ((people != nil) && [people count])
	{
		ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:0];
		ABPersonViewController *picker = [[ABPersonViewController alloc] init];
		picker.personViewDelegate = self;
		picker.displayedPerson = person;
		// Allow users to edit the person’s information
		picker.allowsEditing = YES;
		[self.navigationController pushViewController:picker animated:YES];
	}
	else 
	{
		// Show an alert if "Appleseed" is not in Contacts
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Could not find Appleseed in the Contacts application" 
													   delegate:nil 
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:nil];
		[alert show];
	}
}

#pragma mark Create a new person
// Called when users tap "Create New Contact" in the application. Allows users to create a new contact.
#warning http://blog.csdn.net/liulushi_1988/article/details/9902845
#warning http://www.cnblogs.com/cpcpc/archive/2012/07/17/2594959.html
-(void)showNewPersonViewController
{
	ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
//	ABRecordRef
    // 初始化一个ABAddressBookRef对象，使用完之后需要进行释放，
    // 这里使用CFRelease进行释放
    // 相当于通讯录的一个引用
    //ABAddressBookRef addressBook = ABAddressBookCreate();
    // 新建一个联系人
    // ABRecordRef是一个属性的集合，相当于通讯录中联系人的对象
    // 联系人对象的属性分为两种：
    // 只拥有唯一值的属性和多值的属性。
    // 唯一值的属性包括：姓氏、名字、生日等。
    // 多值的属性包括:电话号码、邮箱等。
    ABRecordRef person = ABPersonCreate();
    NSString *firstName = @"黄";
    NSString *lastName = @"成都";
    NSDate *birthday = [NSDate date];
    // 电话号码数组
    NSArray *phones = [NSArray arrayWithObjects:@"123",@"456", nil];
    // 电话号码对应的名称
    NSArray *labels = [NSArray arrayWithObjects:@"iphone",@"home", nil];
    // 保存到联系人对象中，每个属性都对应一个宏，例如：kABPersonFirstNameProperty
    // 设置firstName属性
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, NULL);
    // 设置lastName属性
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef) lastName, NULL);
    // 设置birthday属性
    ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFDateRef)birthday, NULL);
    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
    ABMultiValueRef mv = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (NSUInteger i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv, (__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &mi);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
    //设置邮箱
    mv = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(mv, @"annkey@qq.con", kABWorkLabel, NULL);
     ABRecordSetValue(person, kABPersonEmailProperty, mv, NULL);
    // 释放该数组
    if (mv) {
        CFRelease(mv);
    }
    picker.displayedPerson = person;
    // 将新建的联系人添加到通讯录中
    //ABAddressBookAddRecord(picker.addressBook, person, NULL);
    // 保存通讯录数据
    //ABAddressBookSave(picker.addressBook, NULL);
    // 释放通讯录对象的引用
//    if (addressBook) {
//        CFRelease(addressBook);
//    }
    
  //=====================================================
//    ABAddressBookRef adbk= picker.addressBook;   //ABAddressBookCreate();//获取本地通讯录数据库
////    ABRecordRef moi=NULL;//联系人
//    ABRecordRef annkey=ABPersonCreate();//创建联系人
//    //设置联系人的值
//    ABRecordSetValue(annkey,kABPersonFirstNameProperty, @"黄", NULL);
//    ABRecordSetValue(annkey,kABPersonLastNameProperty, @"成都", NULL);
//    //创建多值属性
//    ABMutableMultiValueRef addr=ABMultiValueCreateMutable(kABStringPropertyType);
//    
//    //增加属性名和属性值，属性名为kABHomeLabel
//    int32_t number = 342342342342;
//    ABMultiValueAddValueAndLabel(addr, @"annkey@qq.con", kABWorkLabel, NULL);
////    ABMultiValueAddValueAndLabel(addr, @(number), kABPersonFirstNamePhoneticProperty, NULL);
//    ABMultiValueAddValueAndLabel(addr, @"1464564565", kABPersonPhoneMobileLabel, NULL);
//    //设置联系人的多值邮箱属性
//    ABRecordSetValue(annkey, kABPersonEmailProperty, addr, NULL);
//    
//    ABAddressBookAddRecord(adbk, annkey, NULL); //增加联系人
//    //ABAddressBookSave(adbk, NULL);//保存联系人
//    picker.displayedPerson = annkey;
//    CFRelease(addr);
//    CFRelease(annkey);//，即使是在arc机制里，c对象仍需手动释放
    //========================
//    CFArrayRef sams=ABAddressBookCopyPeopleWithName(adbk, (CFStringRef)@"黄");//联系人数组，可能存在多个同名的联系人，需要通过其他属性来判断具体是哪个
//    for (CFIndex ix=0; ix<CFArrayGetCount(sams); ix++) {
//        // 从联系人数组多个sam中读取
//        ABRecordRef sam=CFArrayGetValueAtIndex(sams, ix);
//        //  获取联系人的名属性
//        CFStringRef last=ABRecordCopyValue(sam, kABPersonLastNameProperty);
//        NSLog(@" is find %@",last);
//        //找到符合条件的联系人
//        if (last&&CFStringCompare(last, (CFStringRef)@"annkey", 0)==0) {
//            moi=sam;
//        }
//        if (last) {
//            CFRelease(last);  //c对象需手动释放
//        }
//    }
//    if (NULL==moi) {
//        CFRelease(sams);
//        CFRelease(adbk);//c对象需手动释放
//        return;
//    }
//    //获取联系人的邮件属性，初始化为多值
//    ABMultiValueRef emails=ABRecordCopyValue(moi, kABPersonEmailProperty);
//    if (NULL==emails) {
//        NSLog(@"emails is null");
//    }
//    for (CFIndex ix=0; ix<ABMultiValueGetCount(emails); ix++) {
//        //联系人的属性名和属性值
//        CFStringRef labe1=ABMultiValueCopyLabelAtIndex(emails, ix);
//        CFStringRef value=ABMultiValueCopyValueAtIndex(emails, ix);
//        NSLog(@"i have a %@ address I%@",labe1,value);
//        CFRelease(labe1);
//        CFRelease(value);
//    }
//    NSLog(@"emails is null2");
//    CFRelease(emails);
//    CFRelease(sams);
//    CFRelease(adbk);
    
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigation animated:YES completion:nil];
}





#pragma mark Add data to an existing person
// Called when users tap "Edit Unknown Contact" in the application. 
-(void)showUnknownPersonViewController
{
	ABRecordRef aContact = ABPersonCreate();
	CFErrorRef anError = NULL;
	ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	bool didAdd = ABMultiValueAddValueAndLabel(email, @"John-Appleseed@mac.com", kABOtherLabel, NULL);
	
	if (didAdd == YES)
	{
		ABRecordSetValue(aContact, kABPersonEmailProperty, email, &anError);
		if (anError == NULL)
		{
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = aContact;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = YES;
			picker.alternateName = @"John Appleseed";
			picker.title = @"John Appleseed";
			picker.message = @"Company, Inc";
			
			[self.navigationController pushViewController:picker animated:YES];
		}
		else 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
															message:@"Could not create unknown user" 
														   delegate:nil 
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:nil];
			[alert show];
		}
	}	
	CFRelease(email);
	CFRelease(aContact);
}


#pragma mark 参考博客地址：http://blog.csdn.net/mmoaay/article/details/41350991

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
#pragma mark iOS8一下
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}
#pragma mark iOS8以下
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phone) > 0) {
        long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
        CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(phone, index);
        NSString *phoneNO = (__bridge NSString *)phoneRef;
        
        if ([phoneNO hasPrefix:@"+"]) {
            phoneNO = [phoneNO substringFromIndex:3];
        }
        phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@", phoneNO);
        CFRelease(phone);
        CFRelease(phoneRef);
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    return YES;
}
#pragma mark 点击取消按钮
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark iOS8以上
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
}
#pragma mark iOS8以上
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    //    CFStringRef firstNameLabel = ABPersonCopyLocalizedPropertyName(kABPersonFirstNameProperty);
    //    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    CFStringRef lastNameLabel = ABPersonCopyLocalizedPropertyName(kABPersonLastNameProperty);
    //    // 姓
    //    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    //    NSLog(@"%@ %@ - %@ %@", lastNameLabel, lastName, firstNameLabel, firstName);
    //
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phone) > 0) {
        long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
        CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(phone, index);
        NSString *phoneNO = (__bridge NSString *)phoneRef;
        
        if ([phoneNO hasPrefix:@"+"]) {
            phoneNO = [phoneNO substringFromIndex:3];
        }
        phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@", phoneNO);
    
        CFRelease(phone);
        CFRelease(phoneRef);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}










#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}






#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller. 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ABUnknownPersonViewControllerDelegate methods
// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact. 
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}

@end
