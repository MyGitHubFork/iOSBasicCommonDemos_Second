//
//  UIView+Extensions.m
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void)setBoundsX:(CGFloat)x
{
    self.bounds = CGRectMake(x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)boundsX
{
    return self.bounds.origin.x;
}

- (void)setBoundsY:(CGFloat)y
{
    self.bounds = CGRectMake(self.bounds.origin.x, y, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)boundsY
{
    return self.bounds.origin.y;
}

- (void)setBoundsWidth:(CGFloat)width
{
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, self.bounds.size.height);
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setBoundsHeight:(CGFloat)height
{
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, height);
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (void)setFrameCenterX:(CGFloat)centerX
{
    self.frame = CGRectMake((centerX - (self.frame.size.width / 2)),
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)frameCenterX
{
    return self.center.x;
}

- (void)setFrameCenterY:(CGFloat)centerY
{
    self.frame = CGRectMake(self.frame.origin.x,
                            (centerY - (self.frame.size.height / 2)),
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)frameCenterY
{
    return self.center.y;
}

- (void)setFrameHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (void)setFrameY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (void)logGeometry
{
    NSLog(@"\n\n");
    NSLog(@"frame.origin.x: %f", self.frame.origin.x);
    NSLog(@"frame.origin.y: %f", self.frame.origin.y);
    NSLog(@"frame.size.width: %f", self.frame.size.width);
    NSLog(@"frame.size.height: %f", self.frame.size.height);
    NSLog(@"bounds.origin.x: %f", self.bounds.origin.x);
    NSLog(@"bounds.origin.y: %f", self.bounds.origin.y);
    NSLog(@"bounds.size.width: %f", self.bounds.size.width);
    NSLog(@"bounds.size.height: %f", self.bounds.size.height);
    NSLog(@"\n\n");
}

@end
