//
//  LLNCFNetworkController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNCFNetworkController.h"
#import <CoreFoundation/CoreFoundation.h> 
#include <sys/socket.h> 
#include <netinet/in.h>

#define kBufferSize 1024

@interface LLNCFNetworkController()

- (void)didReceiveData:(NSData*)data;
- (void)didFinishReceivingData;

@end


@implementation LLNCFNetworkController {
	CFSocketRef		socket;
	NSMutableData	*receivedData;
}

void socketCallback(CFReadStreamRef stream, CFStreamEventType event, void *myPtr) {
    LLNCFNetworkController *controller = (__bridge LLNCFNetworkController*)myPtr;
	
	switch(event) {
        case kCFStreamEventHasBytesAvailable:
			// read bytes until there are no more
            while (CFReadStreamHasBytesAvailable(stream)) {
				UInt8 buffer[kBufferSize];
				int numBytesRead = CFReadStreamRead(stream, buffer, kBufferSize);
				
				[controller didReceiveData:[NSData dataWithBytes:buffer length:numBytesRead]];
			}
			
            break;
			
        case kCFStreamEventErrorOccurred: {
			CFErrorRef error = CFReadStreamCopyError(stream);
			
			if (error != NULL) {
				if (CFErrorGetCode(error) != 0) {
					NSLog(@"Failed while reading stream; error '%@' (code %ld)", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error));
				}
				
				CFRelease(error);
			}
			
			if ([controller.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
				[controller.delegate networkingResultsDidFail:@"An unexpected error occurred while reading from the warehouse server."];
			}
			
            break;
		}
			
        case kCFStreamEventEndEncountered:
			[controller didFinishReceivingData];
			
			// clean up the stream
			CFReadStreamClose(stream);
			
			// stop processing callback methods
			CFReadStreamUnscheduleFromRunLoop(stream,
											  CFRunLoopGetCurrent(),
											  kCFRunLoopCommonModes);
			
			// end the thread's run loop
			CFRunLoopStop(CFRunLoopGetCurrent());

            break;
			
        default:
            break;
    }
}

- (void)loadCurrentStatus:(NSURL*)url {
	if ([self.delegate respondsToSelector:@selector(networkingResultsDidStart)]) {
		[self.delegate networkingResultsDidStart];
	}

	// keep a reference to self to use for controller callbacks
	CFStreamClientContext ctx = {0, (__bridge void *)(self), NULL, NULL, NULL};
	
	// get callbacks for stream data, stream end, and any errors
	CFOptionFlags registeredEvents = (kCFStreamEventHasBytesAvailable | kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred);
	
	
	// create a read-only socket
	CFReadStreamRef readStream;
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
									   (__bridge CFStringRef)[url host],
									   [[url port] integerValue],
									   &readStream,
									   NULL);
	
	
	// schedule the stream on the run loop to enable callbacks
	if (CFReadStreamSetClient(readStream, registeredEvents, socketCallback, &ctx)) {
		CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		
	} else {
		NSLog(@"Failed to assign callback method");
		
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to respond to data from the warehouse server."];
		}
		
		return;
	}
	
	
	// open the stream for reading
	if (CFReadStreamOpen(readStream) == NO) {
		NSLog(@"Failed to open read stream");

		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to read data from the warehouse server."];
		}
		
		return;
	}
	
	CFErrorRef error = CFReadStreamCopyError(readStream);
	
	if (error != NULL) {
		if (CFErrorGetCode(error) != 0) {
			NSLog(@"Failed to connect stream; error '%@' (code %ld)", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error));
		}
		
		CFRelease(error);
		
		if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
			[self.delegate networkingResultsDidFail:@"Unable to connect to the warehouse server."];
		}
		
		return;
	}
	
	NSLog(@"Successfully connected to %@", url);
	
	
	// start processing
	CFRunLoopRun();
}

- (void)didReceiveData:(NSData *)data {
	if (receivedData == nil) {
		receivedData = [[NSMutableData alloc] init];
	}
	
	[receivedData appendData:data];
}

- (void)didFinishReceivingData {
	NSString *resultsString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
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