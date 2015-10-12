//
//  UIImage+UIImage_RoadWay.h
//  mtNew
//
//  Created by zhuqinjian on 15/8/18.
//  Copyright (c) 2015年 MYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_RoadWay)


+ (UIImage *)road:(NSString *)imageName;

/**
 *  修复图像90度问题
 *
 *  @param aImage <#aImage description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
