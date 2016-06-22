//
//  AroundBtn.m
//  eNavi
//
//  Created by zuotoujing on 16/4/1.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "AroundBtn.h"

@implementation AroundBtn


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 50;
    CGFloat H = 50;
    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(X, 0, W, H);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat Y = 50;
    CGFloat H = contentRect.size.height-50;
    //    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(0, Y, W, H);
}

@end
