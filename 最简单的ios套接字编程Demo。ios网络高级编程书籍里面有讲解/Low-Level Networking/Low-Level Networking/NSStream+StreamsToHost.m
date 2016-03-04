//
//  NSStream+StreamsToHost.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "NSStream+StreamsToHost.h"

@implementation NSStream(StreamsToHost)

+ (void)readStreamFromHostNamed:(NSString *)hostName
						   port:(NSInteger)port
					 readStream:(out NSInputStream **)readStreamPtr {
	
    assert(hostName != nil);
    assert((port > 0) && (port < 65536));
    assert((readStreamPtr != NULL));
	
	CFReadStreamRef readStream = NULL;
	
    CFStreamCreatePairWithSocketToHost(NULL,
									   (__bridge CFStringRef) hostName,
									   port,
									   ((readStreamPtr != NULL) ? &readStream : NULL),
									   NULL);
	
    if (readStreamPtr != NULL) {
        *readStreamPtr  = CFBridgingRelease(readStream);
    }
}

@end