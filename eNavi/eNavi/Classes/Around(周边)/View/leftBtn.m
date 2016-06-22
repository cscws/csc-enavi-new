//
//  leftBtn.m
//  eNavi
//
//  Created by zuotoujing on 16/5/22.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "leftBtn.h"

@implementation leftBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 35;
    CGFloat H = 35;
    CGFloat X = (self.width-W-5)/2;
    CGFloat Y = (self.frame.size.height-67)/2;
    return CGRectMake(X, Y, W, H);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = self.width;
    CGFloat Y = CGRectGetMaxY(self.imageView.frame);
    CGFloat H = 32;
   // CGFloat X = self.imageView.frame.origin.x;
    //    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(-2, Y, W, H);
}

@end
