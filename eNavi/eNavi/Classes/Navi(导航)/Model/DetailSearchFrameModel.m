//
//  DetailSearchFrameModel.m
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"

@implementation DetailSearchFrameModel
- (void)setModel:(DetailSearchModel *)model
{
    _model = model;
    CGFloat padding = 10;
    
    CGFloat iconX = 0;
    CGFloat iconY = padding;
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    _numberF = CGRectMake(iconX-0.5, iconY-3, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF);
    CGFloat nameY = 0;
    CGFloat nameW = kMainScreenSizeWidth-50;
    CGFloat nameH = 30;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat addressX = nameX;
    CGFloat addressY = CGRectGetMaxY(_nameF);
    CGFloat addressW = kMainScreenSizeWidth-50;
    CGFloat addressH = 15;
   // CGSize addressSize = [model.address sizeWithFont:font(14.0) maxSize:CGSizeMake(200,MAXFLOAT)];
    _addressF = CGRectMake(addressX, addressY, addressW, addressH);
    
    CGFloat disX = kMainScreenSizeWidth-50;
    CGFloat disY = 0;
    CGFloat disW = 45;
    CGFloat disH = 50;
    _distanceF = CGRectMake(disX, disY, disW, disH);
    _viewH = CGRectGetMaxY(_addressF)+5;
    
}

@end
