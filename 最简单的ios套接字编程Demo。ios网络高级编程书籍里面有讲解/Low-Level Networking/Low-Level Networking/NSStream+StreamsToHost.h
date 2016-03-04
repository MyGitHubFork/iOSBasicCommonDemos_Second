//
//  NSStream+StreamsToHost.h
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream(StreamsToHost)

+ (void)readStreamFromHostNamed:(NSString *)hostName
						   port:(NSInteger)port
					 readStream:(out NSInputStream **)readStreamPtr;

@end