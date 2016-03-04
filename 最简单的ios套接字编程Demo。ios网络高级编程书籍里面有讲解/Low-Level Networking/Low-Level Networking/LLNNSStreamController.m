//
//  LLNNSStreamController.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNNSStreamController.h"
#import "NSStream+StreamsToHost.h"

@implementation LLNNSStreamController {
	NSMutableData *receivedData;
}

- (void)loadCurrentStatus:(NSURL *)url {
	if ([self.delegate respondsToSelector:@selector(networkingResultsDidStart)]) {
		[self.delegate networkingResultsDidStart];
	}
	
	NSInputStream *readStream;
	[NSStream readStreamFromHostNamed:[url host]
								 port:[[url port] integerValue]
						   readStream:&readStream];

	[readStream setDelegate:self];
	[readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[readStream open];
	
	[[NSRunLoop currentRunLoop] run];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	switch (eventCode) {
		case NSStreamEventHasBytesAvailable: {
			if (receivedData == nil) {
                receivedData = [[NSMutableData alloc] init];
            }
			
            uint8_t buf[1024];
            int numBytesRead = [(NSInputStream *)stream read:buf maxLength:1024];
			
            if (numBytesRead > 0) {
                [receivedData appendBytes:(const void *)buf length:numBytesRead];
				
            } else if (numBytesRead == 0) {
                NSLog(@"End of stream reached");
				
            } else {
				NSLog(@"Read error occurred");
			}
			
			break;
		}
			
		case NSStreamEventErrorOccurred: {
			NSError *error = [stream streamError];
			NSLog(@"Failed while reading stream; error '%@' (code %d)", error.localizedDescription, error.code);
			
			if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
				[self.delegate networkingResultsDidFail:@"An unexpected error occurred while reading from the warehouse server."];
			}
			
			[self cleanUpStream:stream];
		}
			
		case NSStreamEventEndEncountered: {
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
			
			[self cleanUpStream:stream];
			
			break;
		}
			
		default:
			break;
	}
}

- (void)cleanUpStream:(NSStream*)stream {
	[stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[stream close];
	
	stream = nil;
}

@end