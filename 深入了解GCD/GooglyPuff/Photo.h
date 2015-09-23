//
//  Photo.h
//  GooglyPuff
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAsset;
typedef void (^PhotoDownloadingCompletionBlock)(UIImage *image, NSError *error);
typedef NS_ENUM(NSInteger, PhotoStatus) {
    PhotoStatusDownloading,
    PhotoStatusGoodToGo,
    PhotoStatusFailed,
};

/**
 Photo is a class cluster object that holds the photo data
 @note The Photo class expects you to use one of the predefined init methods instead of the normal init method.
 */
@interface Photo : NSObject

/// Returns the PhotoStatus, used to determine if the photo can currently be displayed or not
@property (nonatomic, readonly, assign) PhotoStatus status;

/// The original image
- (UIImage *)image;

/// Scaled down image of the original image
- (UIImage *)thumbnail;

- (instancetype)initWithAsset:(ALAsset *)asset;
- (instancetype)initwithURL:(NSURL *)url;
- (instancetype)initwithURL:(NSURL *)url withCompletionBlock:(PhotoDownloadingCompletionBlock)completionBlock;
@end
