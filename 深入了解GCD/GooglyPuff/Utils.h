//
//  Utils.h
//  GCDTutorial
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

/** @file */
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

/// Notification when new photo instances are added
extern NSString *const kPhotoManagerAddedContentNotification;

/// Notification when content updates (i.e. Download finishes)
extern NSString *const kPhotoManagerContentUpdateNotification;

/// Photo Credit: Devin Begley, http://www.devinbegley.com/
extern NSString *const kLotsOfFacesURLString;
extern NSString *const kOverlyAttachedGirlfriendURLString;
extern NSString *const kSuccessKidURLString;

@interface Utils : NSObject

+ (UIColor *)defaultBackgroundColor;
BOOL isIpad();
+ (void)startTimeProfiling;
+ (void)stopTimeProfiling;
@end
