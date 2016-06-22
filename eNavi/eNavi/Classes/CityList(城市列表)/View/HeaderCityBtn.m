//
//  HeaderCityBtn.m
//  eNavi
//
//  Created by zuotoujing on 16/3/21.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "HeaderCityBtn.h"

@implementation HeaderCityBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX=self.frame.size.width-40;
    CGFloat imageY=0;
    CGFloat width=40;
    CGFloat height=40;
    return CGRectMake(imageX, imageY, width, height);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX=5;
    CGFloat imageY=0;
    CGFloat width=200;
    CGFloat height=40;
    return CGRectMake(imageX, imageY, width, height);
    
}

@end
