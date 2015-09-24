//  PhotoManager.m
//  PhotoFilter
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

@import CoreImage;
@import AssetsLibrary;
#import "PhotoManager.h"

@interface PhotoManager ()
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue; ///< Add this
@end

@implementation PhotoManager

+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSThread sleepForTimeInterval:2];
        sharedPhotoManager = [[PhotoManager alloc] init];
        NSLog(@"Singleton has memory address at: %@", sharedPhotoManager);
        [NSThread sleepForTimeInterval:2];
        sharedPhotoManager->_photosArray = [NSMutableArray array];
        sharedPhotoManager.concurrentPhotoQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return sharedPhotoManager;
}

//*****************************************************************************/
#pragma mark - Unsafe Setter/Getters
//*****************************************************************************/

- (NSArray *)photos
{
    return _photosArray;
}
/**
 *  下面是你何时会——和不会——使用障碍函数的情况：
 
 自定义串行队列：一个很坏的选择；障碍不会有任何帮助，因为不管怎样，一个串行队列一次都只执行一个操作。
 全局并发队列：要小心；这可能不是最好的主意，因为其它系统可能在使用队列而且你不能垄断它们只为你自己的目的。
 自定义并发队列：这对于原子或临界区代码来说是极佳的选择。任何你在设置或实例化的需要线程安全的事物都是使用障碍的最佳候选。
/**
 *
 1在执行下面所有的工作前检查是否有合法的相片。
 2添加写操作到你的自定义队列。当临界区在稍后执行时，这将是你队列中唯一执行的条目。
 3这是添加对象到数组的实际代码。由于它是一个障碍 Block ，这个 Block 永远不会同时和其它 Block 一起在 concurrentPhotoQueue 中执行。
 4最后你发送一个通知说明完成了添加图片。这个通知将在主线程被发送因为它将会做一些 UI 工作，所以在此为了通知，你异步地调度另一个任务到主线程。
 */
- (void)addPhoto:(Photo *)photo
{
    if (photo) { // 1
        dispatch_barrier_async(self.concurrentPhotoQueue, ^{ // 2
            [_photosArray addObject:photo]; // 3
            dispatch_async(dispatch_get_main_queue(), ^{ // 4
                [self postContentAddedNotification];
            });
        });
    }
}

//*****************************************************************************/
#pragma mark - Public Methods
//*****************************************************************************/

- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock
{
    __block NSError *error;
    
    for (NSInteger i = 0; i < 3; i++) {
        NSURL *url;
        switch (i) {
            case 0:
                url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
                break;
            case 1:
                url = [NSURL URLWithString:kSuccessKidURLString];
                break;
            case 2:
                url = [NSURL URLWithString:kLotsOfFacesURLString];
                break;
            default:
                break;
        }
    
        Photo *photo = [[Photo alloc] initwithURL:url
                              withCompletionBlock:^(UIImage *image, NSError *_error) {
                                  if (_error) {
                                      error = _error;
                                  }
                              }];
    
        [[PhotoManager sharedManager] addPhoto:photo];
    }
    
    if (completionBlock) {
        completionBlock(error);
    }
}

//*****************************************************************************/
#pragma mark - Private Methods
//*****************************************************************************/

- (void)postContentAddedNotification
{
    static NSNotification *notification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notification = [NSNotification notificationWithName:kPhotoManagerAddedContentNotification object:nil];
    });
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
}

@end
