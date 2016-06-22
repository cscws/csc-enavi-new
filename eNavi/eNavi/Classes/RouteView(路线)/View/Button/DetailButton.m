//
//  DetailButton.m
//  eNavi
//
//  Created by zuotoujing on 16/4/7.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "DetailButton.h"

@implementation DetailButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat Y = 33;
    CGFloat H = contentRect.size.height-Y;
    //    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(0, Y, W, H);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 30;
    CGFloat H = 30;
    CGFloat X = (contentRect.size.width-W)/2;
    return CGRectMake(X, 3, W, H);
}


@end
