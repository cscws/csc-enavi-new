//
//  KCBtn.m
//  eNavi
//
//  Created by zuotoujing on 16/3/7.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCBtn.h"

@implementation KCBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX=(((kMainScreenSizeWidth)/3)-40)/2;
    CGFloat imageY=10;
    CGFloat width=40;
    CGFloat height=40;
    return CGRectMake(imageX, imageY, width, height);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX=(((kMainScreenSizeWidth)/3)-60)/2;
    CGFloat imageY=50;
    CGFloat width=60;
    CGFloat height=30;
    return CGRectMake(imageX, imageY, width, height);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
