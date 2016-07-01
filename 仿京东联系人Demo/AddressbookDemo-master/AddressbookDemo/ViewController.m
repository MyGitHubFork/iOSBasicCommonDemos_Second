//
//  ViewController.m
//  AddressbookDemo
//
//  Created by Donal on 14-1-8.
//  Copyright (c) 2014年 vikaa. All rights reserved.
//

#import "ViewController.h"
#import "RHAddressBook.h"
#import "RHPerson.h"
#import "pinyin.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()
{
    RHAddressBook *addressBook;
    NSMutableDictionary *friendDictionary;
    NSMutableArray *friendAplha;
    
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RHAddressBook *ab = [[RHAddressBook alloc] init] ;
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        __weak id this = self;
        [ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            [this initData:ab];
        }];
    }
    
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录提示" message:@"请在iPhone的[设置]->[隐私]->[通讯录]，允许群友通讯录访问你的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // warn re restricted access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录提示" message:@"请在iPhone的[设置]->[隐私]->[通讯录]，允许群友通讯录访问你的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self initData:ab];
}

-(void)initData:(RHAddressBook *)ad
{
    addressBook = ad;
    friendAplha = [NSMutableArray array];
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *people = [addressBook peopleOrderedByUsersPreference];
        for (RHPerson *person in people) {
            NSString *c = [[person.name substringToIndex:1] uppercaseString];
            if ([predicate evaluateWithObject:c]) {
                [person setFirstNamePhonetic:c];
            }
            else {
                NSString *alpha = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([person.name characterAtIndex:0])] uppercaseString];
                [person setFirstNamePhonetic:alpha];
            }
        }
        
        NSArray *sortedArray;
        sortedArray = [people sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                       {
                           NSString *first = [(RHPerson*)a firstNamePhonetic];
                           NSString *second = [(RHPerson*)b firstNamePhonetic];
                           return [first compare:second];
                       }];
        
        NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (RHPerson *person in sortedArray) {
            NSString *spellKey = person.firstNamePhonetic;
            if ([sectionDict objectForKey:spellKey]) {
                NSMutableArray *currentSecArray = [sectionDict objectForKey:spellKey];
                [currentSecArray addObject:person];
            }
            else {
                [friendAplha addObject:spellKey];
                NSMutableArray *currentSecArray = [[NSMutableArray alloc] initWithCapacity:0];
                [currentSecArray addObject:person];
                [sectionDict setObject:currentSecArray forKey:spellKey];
            }
        }
        
        friendDictionary = sectionDict;
        
        //索引数组
        dataSource = [[NSMutableArray alloc] init] ;
        for(char c = 'A'; c <= 'Z'; c++ )
        {
            [dataSource addObject:[NSString stringWithFormat:@"%c",c]];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mtableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [_mtableView reloadData];
        });
    });
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return friendAplha.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    NSString *key = [friendAplha objectAtIndex:section];
    view.textLabel.text = key;
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in friendAplha)
    {
        if([character isEqualToString:title]) {
            return count;
        }
        count ++;
    }
    return count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [friendAplha objectAtIndex:section];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [friendAplha objectAtIndex:section];
    NSArray *keyArray = [friendDictionary objectForKey:key];
    return keyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier    = @"friend";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *alpha     = [friendAplha objectAtIndex:indexPath.section];
    NSArray *alphaArray = [friendDictionary objectForKey:alpha];
    RHPerson *person    = [alphaArray objectAtIndex:indexPath.row];
    person.firstNamePhonetic = @"";
    cell.textLabel.text = person.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: push our own viewer view, for now just use the AB default one.
    NSString *alpha     = [friendAplha objectAtIndex:indexPath.section];
    NSArray *alphaArray = [friendDictionary objectForKey:alpha];
    RHPerson *person    = [alphaArray objectAtIndex:indexPath.row];
    
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    
    //setup (tell the view controller to use our underlying address book instance, so our person object is directly updated)
    [person.addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
        personViewController.addressBook =addressBookRef;
    } waitUntilDone:YES];
    
    personViewController.displayedPerson = person.recordRef;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    personViewController.allowsActions = YES;
#endif
    personViewController.allowsEditing = YES;
    
    
    [self.navigationController pushViewController:personViewController animated:YES];
}

@end
