//
//  LLNViewController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNViewController.h"
#import "LLNBSDSocketController.h"
#import "LLNCFNetworkController.h"
#import "LLNNSStreamController.h"

//#warning Fill in your example telnet server here
#define kWarehouseFeedHost @"tt.80gd.cn"
#define kWarehouseFeedPort 8080


@interface LLNViewController(){
	LLNNetworkingResult *mostRecentResults;
	NSNumberFormatter	*formatter;
}

@end


@implementation LLNViewController

@synthesize refreshButton, tableView, networkingTypeSelector;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	mostRecentResults = nil;
	
	formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMinimumFractionDigits:1];
	[formatter setMaximumFractionDigits:2];
}


#pragma mark - UI response

- (void)refreshButtonTapped:(id)sender {
	// determine which type of networking to use
	switch (self.networkingTypeSelector.selectedSegmentIndex) {
			
		// BSD sockets
		case 0: {
			LLNBSDSocketController *bsdSocketController = [[LLNBSDSocketController alloc] initWithURLString:kWarehouseFeedHost port:kWarehouseFeedPort];
			bsdSocketController.delegate = self;
			
			[bsdSocketController start];
			break;
		}
		
		// CFNetwork
		case 1: {
			LLNCFNetworkController *cfNetworkController = [[LLNCFNetworkController alloc] initWithURLString:kWarehouseFeedHost port:kWarehouseFeedPort];
			cfNetworkController.delegate = self;
			
			[cfNetworkController start];
			break;
		}
		
		// NSStream
		case 2: {
			LLNNSStreamController *nsStreamController = [[LLNNSStreamController alloc] initWithURLString:kWarehouseFeedHost port:kWarehouseFeedPort];
			nsStreamController.delegate = self;
			
			[nsStreamController start];
			break;
		}
			
		default:
			break;
	}
	
	self.refreshButton.enabled = NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"resultCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    
    switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Room Temperature";
			
			if (mostRecentResults.temperatureRoom != nil) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@°F", [formatter stringFromNumber:mostRecentResults.temperatureRoom]];
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 1:
			cell.textLabel.text = @"Outlet Temperature";
			
			if (mostRecentResults.temperatureOutlet != nil) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@°F", [formatter stringFromNumber:mostRecentResults.temperatureOutlet]];
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 2:
			cell.textLabel.text = @"Coil Temperature";
			
			if (mostRecentResults.temperatureCoil != nil) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@°F", [formatter stringFromNumber:mostRecentResults.temperatureCoil]];
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 3:
			cell.textLabel.text = @"Compressor";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusCompressorOn ? @"On" : @"Off");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 4:
			cell.textLabel.text = @"Air Switch";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusAirSwitchOn ? @"On" : @"Off");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 5:
			cell.textLabel.text = @"Auxilary Heat";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusAuxilaryHeatOn ? @"On" : @"Off");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 6:
			cell.textLabel.text = @"Front Door";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusFrontDoorOpen ? @"Open" : @"Closed");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 7:
			cell.textLabel.text = @"System Status";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusSystemStandby ? @"Standby" : @"Ready");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		case 8:
			cell.textLabel.text = @"Alarm";
			
			if (mostRecentResults != nil) {
				cell.detailTextLabel.text = (mostRecentResults.statusAlarmActive ? @"Active" : @"Normal");
			} else {
				cell.detailTextLabel.text = nil;
			}
			
			break;
			
		default:
			cell.textLabel.text = nil;
			cell.detailTextLabel.text = nil;
			break;
	}
	
    return cell;
}


#pragma mark - LLNNetworkingResultDelegate

- (void)networkingResultsDidStart {
	// perform UI updates on the main thread
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	});
}

- (void)networkingResultsDidLoad:(LLNNetworkingResult *)results {
	mostRecentResults = results;
	
	// perform UI updates on the main thread
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.refreshButton.enabled = YES;

		[self.tableView reloadData];
	});
}

- (void)networkingResultsDidFail:(NSString *)errorMessage {
	// perform UI updates on the main thread
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.refreshButton.enabled = YES;
		
		[[[UIAlertView alloc] initWithTitle:@"Error"
									message:errorMessage
								   delegate:nil
						  cancelButtonTitle:@"Okay"
						  otherButtonTitles:nil] show];
	});
}

@end