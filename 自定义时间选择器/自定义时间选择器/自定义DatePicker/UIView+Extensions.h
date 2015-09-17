//
//  UIView+Extensions.h
//

@import UIKit;

@interface UIView (Extensions)

@property (nonatomic) CGFloat boundsHeight;
@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsX;
@property (nonatomic) CGFloat boundsY;
@property (nonatomic) CGFloat frameCenterX;
@property (nonatomic) CGFloat frameCenterY;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

- (void)logGeometry;

@end
