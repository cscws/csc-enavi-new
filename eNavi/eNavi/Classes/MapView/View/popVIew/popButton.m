//
//  popButton.m
//  eNavi
//
//  Created by zuotoujing on 16/4/27.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "popButton.h"

@implementation popButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 30;
    CGFloat H = 30;
    CGFloat X = (contentRect.size.width-W)/2;
    CGFloat Y = (contentRect.size.height-50)/2;
    return CGRectMake(X, Y, W, H);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat Y = 33;
    CGFloat H = 30;
    //    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(0, Y, W, H);
}


@end
