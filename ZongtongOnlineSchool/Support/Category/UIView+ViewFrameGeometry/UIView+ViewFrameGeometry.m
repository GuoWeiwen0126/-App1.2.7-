//
//  UIView+ViewFrameGeometry.m
//  XiaoXiaQuestionBank
//
//  Created by GuoWeiwen on 2017/1/19.
//  Copyright © 2017年 GuoWeiwen. All rights reserved.
//

#import "UIView+ViewFrameGeometry.h"

@implementation UIView (ViewFrameGeometry)

- (CGFloat) height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)newHeight
{
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
}

- (CGFloat) width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)newWidth
{
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)newTop
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = newTop;
    self.frame = newFrame;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)newLeft
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = newLeft;
    self.frame = newFrame;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)newBottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newBottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight: (CGFloat)newRight
{
    CGFloat delta = newRight - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

@end
