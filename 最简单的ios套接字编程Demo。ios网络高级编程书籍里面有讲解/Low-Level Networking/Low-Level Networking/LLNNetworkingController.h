//
//  LLNNetworkingController.h
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNNetworkingResult.h"

@protocol LLNNetworkingDelegate <NSObject>

- (void)networkingResultsDidStart;
- (void)networkingResultsDidLoad:(LLNNetworkingResult*)results;
- (void)networkingResultsDidFail:(NSString*)errorMessage;

@end


@interface LLNNetworkingController : NSObject

@property(nonatomic,readonly)	NSString					*urlString;
@property(nonatomic,readonly)	NSInteger					portNumber;
@property(nonatomic,strong)		id<LLNNetworkingDelegate>	delegate;

- (id)initWithURLString:(NSString*)urlString port:(NSInteger)portNumber;
- (void)start;
- (void)loadCurrentStatus:(NSURL*)url;
- (LLNNetworkingResult*)parseResultString:(NSString*)resultString;

@end