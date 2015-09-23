//
//  GooglyPuffTests.m
//  GooglyPuffTests
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

#import <XCTest/XCTest.h>

const int64_t kDefaultTimeoutLengthInNanoSeconds = 10000000000; // 10 Seconds

@interface GooglyPuffNetworkIntegrationTests : XCTestCase
@end


@implementation GooglyPuffNetworkIntegrationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testMikeAshImageURL
{
    [self downloadImageURLWithString:kLotsOfFacesURLString];
}

- (void)testMattThompsonImageURL
{
    [self downloadImageURLWithString:kSuccessKidURLString];
}

- (void)testAaronHillegassImageURL
{
    [self downloadImageURLWithString:kOverlyAttachedGirlfriendURLString];
}

- (void)downloadImageURLWithString:(NSString *)URLString
{
    NSURL *url = [NSURL URLWithString:URLString];
    __block BOOL isFinishedDownloading = NO;
    __unused Photo *photo = [[Photo alloc]
                             initwithURL:url
                             withCompletionBlock:^(UIImage *image, NSError *error) {
                                 if (error) {
                                     XCTFail(@"%@ failed. %@", URLString, error);
                                 }
                                 isFinishedDownloading = YES;
                             }];
    
    while (!isFinishedDownloading) {}
}

@end
