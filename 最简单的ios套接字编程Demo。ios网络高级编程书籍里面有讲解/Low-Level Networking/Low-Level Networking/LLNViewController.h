//
//  LLNViewController.h
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLNNetworkingController.h"

@interface LLNViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LLNNetworkingDelegate>

@property(nonatomic,strong) IBOutlet UIBarButtonItem	*refreshButton;
@property(nonatomic,strong) IBOutlet UISegmentedControl *networkingTypeSelector;
@property(nonatomic,strong) IBOutlet UITableView		*tableView;

- (IBAction)refreshButtonTapped:(id)sender;

@end