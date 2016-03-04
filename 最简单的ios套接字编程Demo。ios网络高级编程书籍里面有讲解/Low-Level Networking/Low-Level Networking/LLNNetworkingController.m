//
//  LLNNetworkingController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNNetworkingController.h"

@interface LLNNetworkingController()

@property(nonatomic,readwrite)	NSString	*urlString;
@property(nonatomic,readwrite)	NSInteger	portNumber;

@end


@implementation LLNNetworkingController

@synthesize delegate;

@synthesize urlString, portNumber;

- (id)initWithURLString:(NSString*)newUrlString port:(NSInteger)newPortNumber {
	self = [super init];
	
	if (self != nil) {
		self.urlString = newUrlString;
		self.portNumber = newPortNumber;
	}
	
	return self;
}

- (void)start {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telnet://%@:%i", self.urlString, self.portNumber]];
	
	NSThread *backgroundThread = [[NSThread alloc] initWithTarget:self
														 selector:@selector(loadCurrentStatus:)
														   object:url];
	[backgroundThread start];
}

- (void)loadCurrentStatus:(NSURL*)url {
	NSLog(@"Warning: this loadCurrentStatus: implementation doesn't do anything, please use a subclass.");
}


- (LLNNetworkingResult*)parseResultString:(NSString*)resultString {
	LLNNetworkingResult *results = [[LLNNetworkingResult alloc] init];
	
	/*
	 * results will appear in the form: 
	 *		84,60,+67,1,1,0,0,0,1
	 *		{room temperature},{outlet temperature},{coil temperature},{compressor status},{air switch status},{auxiliary heat status},{front door status},{system status},{alarm status}
	 */
	NSArray *components = [resultString componentsSeparatedByString:@","];
	
	// if we didn't get the expected results, return nothing
	if ([components count] < 9) {
		return nil;
	}
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	
	NSNumberFormatter *formatterWithPlusSign = [[NSNumberFormatter alloc] init];
	[formatterWithPlusSign setPositivePrefix:@"+"];
	
	results.temperatureRoom = [formatter numberFromString:[components objectAtIndex:0]];
	results.temperatureOutlet = [formatter numberFromString:[components objectAtIndex:1]];
	results.temperatureCoil = [formatterWithPlusSign numberFromString:[components objectAtIndex:2]];
	results.statusCompressorOn = [[formatter numberFromString:[components objectAtIndex:3]] boolValue];
	results.statusAirSwitchOn = [[formatter numberFromString:[components objectAtIndex:4]] boolValue];
	results.statusAuxilaryHeatOn = [[formatter numberFromString:[components objectAtIndex:5]] boolValue];
	results.statusFrontDoorOpen = [[formatter numberFromString:[components objectAtIndex:6]] boolValue];
	results.statusSystemStandby = [[formatter numberFromString:[components objectAtIndex:7]] boolValue];
	results.statusAlarmActive = [[formatter numberFromString:[components objectAtIndex:8]] boolValue];
	
	return results;
}

@end