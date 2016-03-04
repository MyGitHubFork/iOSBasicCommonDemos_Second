//
//  LLNBSDSocketController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNBSDSocketController.h"
#import <arpa/inet.h>
#import <netdb.h>

@implementation LLNBSDSocketController {
	int socketFileDescriptor;
}

- (void)loadCurrentStatus:(NSURL*)url {
	if ([self.delegate respondsToSelector:@selector(networkingResultsDidStart)]) {
		[self.delegate networkingResultsDidStart];
	}
	
	// create a new Internet stream socket
	socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
	
	if (socketFileDescriptor == -1) {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to allocate networking resources."];
		}
		
		return;
	}
	
	
	// convert the hostname to an IP address
	struct hostent *remoteHostEnt = gethostbyname([[url host] UTF8String]);
	
	if (remoteHostEnt == NULL) {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to resolve the hostname of the warehouse server."];
		}
		
		return;
	}
	
	struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
	
	// set the socket parameters to open that IP address
	struct sockaddr_in socketParameters;
	socketParameters.sin_family = AF_INET;
	socketParameters.sin_addr = *remoteInAddr;
	socketParameters.sin_port = htons([[url port] intValue]);
	
	// connect the socket; a return code of -1 indicates an error
	if (connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters)) == -1) {
		NSLog(@"Failed to connect to %@", url);
		
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to connect to the warehouse server."];
		}
		
		return;
	}
	
	NSLog(@"Successfully connected to %@", url);

	NSMutableData *data = [[NSMutableData alloc] init];
	BOOL waitingForData = YES;
	
	// continually receive data until we reach the end of the data
	while (waitingForData){
		const char *buffer[1024];
		int length = sizeof(buffer);
		
		// read a buffer's amount of data from the socket; the number of bytes read is returned
		int result = recv(socketFileDescriptor, &buffer, length, 0);
		
		// if we got data, append it to the buffer and keep looping
		if (result > 0){
			[data appendBytes:buffer length:result];
			
		// if we didn't get any data, stop the receive loop
		} else {
			waitingForData = NO;
		}
	}
	
	// close the stream since we're done reading
	close(socketFileDescriptor);
	
	
	NSString *resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Received string: '%@'", resultsString);
	
	LLNNetworkingResult *result = [self parseResultString:resultsString];
	
	if (result != nil) {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidLoad:)]) {
			[self.delegate networkingResultsDidLoad:result];
		}
		
	} else {
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to parse the response from the warehouse server."];
		}
	}
}

@end