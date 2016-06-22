//
//  BackView.m
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "BackView.h"
#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"
@interface BackView ()

@property (nonatomic, weak)UILabel *nmLabel;
@property (nonatomic, weak)UILabel *addressLabel;
@property (nonatomic, weak)UILabel *distanceLabel;
@end

@implementation BackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        //imgView.backgroundColor =[UIColor redColor];
        self.imgView = imgView;
        
        UILabel *numberLabel = [[UILabel alloc] init];
        [self addSubview:numberLabel];
        //numberLabel.backgroundColor = [UIColor blueColor];
        self.numberLabel = numberLabel;
        
        UILabel *nmLabel = [[UILabel alloc] init];
        [self addSubview:nmLabel];
        self.nmLabel = nmLabel;
        
        UILabel *address = [[UILabel alloc] init];
        [self addSubview:address];
        self.addressLabel = address;
        
        UILabel *disteanceLabel = [[UILabel alloc] init];
        [self addSubview:disteanceLabel];
        self.distanceLabel = disteanceLabel;

    }
    return self;
}

- (void)setFrameModel:(DetailSearchFrameModel *)frameModel
{
    _frameModel = frameModel;
}

- (void)layoutSubviews
{
    [self setSubViewframe];
    [self setSubViewData];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSubViewframe
{
    _imgView.frame = _frameModel.iconF;
    _numberLabel.frame = _frameModel.numberF;
    _nmLabel.frame = _frameModel.nameF;
    _addressLabel.frame = _frameModel.addressF;
    _distanceLabel.frame = _frameModel.distanceF;
    self.frame = CGRectMake(0, 2, kMainScreenSizeWidth, _frameModel.viewH);
}

- (void)setSubViewData
{
    _nmLabel.text = _frameModel.model.name;
    _nmLabel.textColor = kTextFontColor;
   // _numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_frameModel.model.i];
    _numberLabel.textColor = kNaviColor;
    _numberLabel.font = font(8.0);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
   // _imgView.image = [UIImage imageNamed:@"poi"];
    _addressLabel.text = _frameModel.model.address;
    _addressLabel.textColor = kTextFontColor;
    _addressLabel.font = font(14.0);
//    self.addressLabel.numberOfLines = 2;
    //距离
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",(_frameModel.model.distance/1000.0)];
    _distanceLabel.textColor = kTextFontColor;
    _distanceLabel.font = [UIFont systemFontOfSize:12.0];
    
}

@end
