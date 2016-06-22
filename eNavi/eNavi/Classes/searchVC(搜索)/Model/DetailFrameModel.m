//
//  DetailFrameModel.m
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.

#import "DetailFrameModel.h"
#import "DetailModel.h"
@implementation DetailFrameModel

- (void)setModel:(DetailModel *)model
{
    _model = model;
    CGFloat padding = 10;
    
    CGFloat iconX = 5;
    CGFloat iconY = padding;
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    _numberF = CGRectMake(iconX-0.5, iconY-3, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF)+5;
    CGFloat nameY = 0;
    CGFloat nameW = 240;
    CGFloat nameH = 30;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat distanceX = kMainScreenSizeWidth-50;
    CGFloat distanceY = nameY;
    CGFloat distanceW = 40;
    CGFloat distanceH = 30;
    _distanceF = CGRectMake(distanceX, distanceY, distanceW, distanceH);
    
    CGFloat addressX = nameX;
    CGFloat addressY = CGRectGetMaxY(_nameF);
    CGFloat addressW = kMainScreenSizeWidth-50;
    CGFloat addressH = 20;
  //  CGSize adressSize = [model.address sizeWithFont:font(14.0) maxSize:CGSizeMake(200, MAXFLOAT)];
    _addressF = CGRectMake(addressX, addressY, addressW, addressH);
    
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(_addressF);
    CGFloat lineW = kMainScreenSizeWidth-10;
    CGFloat lineH = 0.5;
    _lineF = CGRectMake(lineX, lineY, lineW, lineH);
 
    CGFloat naviBtnX = 0;
    CGFloat naviBtnY = CGRectGetMaxY(_lineF);
    CGFloat naviBtnW = (kMainScreenSizeWidth-11)/2;
    CGFloat naviBtnH = 30;
    _naviBtnF = CGRectMake(naviBtnX, naviBtnY, naviBtnW, naviBtnH);
    
    CGFloat detailBtnX = CGRectGetMaxX(_naviBtnF);
    CGFloat detailBtnY = CGRectGetMaxY(_lineF);
    CGFloat detailBtnW = naviBtnW;
    CGFloat detailBtnH = 30;
    _detailBtnF = CGRectMake(detailBtnX+1, detailBtnY, detailBtnW, detailBtnH);
    
    _verticalLineF = CGRectMake(detailBtnX, detailBtnY, 0.5, 30);
    
    _viewH = CGRectGetMaxY(_detailBtnF)+2;
        
}

@end
