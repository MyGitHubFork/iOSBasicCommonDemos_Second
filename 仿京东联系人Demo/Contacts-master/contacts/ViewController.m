//
//  ViewController.m
//  contacts
//
//  Created by PhilCai on 15/7/29.
//  Copyright (c) 2015年 Phil. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NVMContactManager.h"
@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *people;
@end
static NSString *const cellIdent = @"person";
@implementation ViewController
- (IBAction)see:(id)sender {
    NVMContactManager *manager = [NVMContactManager manager];
    for (NVMContact *contact in manager.allPeople) {
        NSLog(@"%@", contact);
    }
}

- (NSMutableArray *)people {
    if (!_people) {
        _people = [NSMutableArray array];
    }
    return _people;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allowAccessContacts)
                                                 name:NVMContactAccessAllowedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessDenied)
                                                 name:NVMContactAccessDeniedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessFailed)
                                                 name:NVMContactAccessFailedNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [NVMContactManager manager].allPeople.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NVMContact *contact = (NVMContact *)([NVMContactManager manager].allPeople[indexPath.row]);
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdent];
    NSString *first = contact.firstName;
    NSString *middle = contact.middleName;
    NSString *last = contact.lastName;
    NSMutableString *fullName = [[NSMutableString alloc] init];
    if (first && first.length > 0) {
        [fullName appendString:first];
    }
    if (middle && middle.length > 0) {
        [fullName appendString:middle];
    }
    if (last && last.length > 0) {
        [fullName appendString:last];
    }
    if (fullName.length > 0) {
        cell.textLabel.text = fullName;
    } else {
        cell.textLabel.text = @"";
    }
    cell.detailTextLabel.text = contact.description;
    return cell;
}

#pragma mark - notification action
- (void)allowAccessContacts {
    NSLog(@"accessAllowed");
    [self.tableView reloadData];
}
- (void)accessDenied {
    NSLog(@"accessDenied");
}
- (void)accessFailed {
    NSLog(@"accessFailed");
}
@end
