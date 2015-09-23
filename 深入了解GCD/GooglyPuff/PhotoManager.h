//
//  PhotoManager.h
//  PhotoFilter
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

typedef void (^PhotoProcessingProgressBlock)(CGFloat completionPercentage);
typedef void (^BatchPhotoDownloadingCompletionBlock)(NSError *error);

/**
 PhotoManger is designed for singleton use to manage all the Photo instances the user selects.
 */
@interface PhotoManager : NSObject
+ (instancetype)sharedManager;
/// Warning this is not currently thread safe
- (NSArray *)photos;
/// Warning this is not currently thread safe
- (void)addPhoto:(Photo *)photo;
/// Warning the completion block gets fired too soon
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock;

@end
