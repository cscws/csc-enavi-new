//
//  DetailView.m
//  eNavi
//
//  Created by zuotoujing on 16/5/5.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "DetailView.h"
#import "DetailFrameModel.h"
#import "DetailModel.h"

typedef void(^buttonClick)(UIButton *button,DetailFrameModel *frameModel);
@interface DetailView ()
@property (nonatomic, weak)UIView *bgView;

@property (nonatomic, weak)UILabel *nmLabel;
@property (nonatomic, weak)UILabel *distanceLabel;
@property (nonatomic, weak)UILabel *addressLabel;
@property (nonatomic, weak)UILabel *line;
@property (nonatomic, weak)UIButton *naviB;
@property (nonatomic, weak)UIButton *deatailBtn;
@property (nonatomic, weak)UILabel *verticalLine;
@property (nonatomic, copy)buttonClick buttonC;
@end

@implementation DetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIView *view =[[UIView alloc] init];
        [self addSubview:view];
        self.bgView = view;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        self.imgView = imgView;
        
        UILabel *numberLabel = [[UILabel alloc] init];
        [self addSubview:numberLabel];
        self.numberLabel = numberLabel;
        
        UILabel *nmLabel = [[UILabel alloc] init];
        [self addSubview:nmLabel];
        self.nmLabel = nmLabel;
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        [self addSubview:distanceLabel];
        self.distanceLabel = distanceLabel;
        
        UILabel *address = [[UILabel alloc] init];
        [self addSubview:address];
        self.addressLabel = address;
        
        UILabel *line = [[UILabel alloc] init];
        [self addSubview:line];
        self.line = line;
        
        UIButton *naviB = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:naviB];
        self.naviB = naviB;
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:detailBtn];
        self.deatailBtn = detailBtn;
        
        UILabel *verticalLine = [[UILabel alloc] init];
        [self addSubview:verticalLine];
        self.verticalLine = verticalLine;

    }
    
    return self;
}

- (void)setDetailFrameModel:(DetailFrameModel *)detailFrameModel
{
    _detailFrameModel = detailFrameModel;
}

- (void)layoutSubviews
{
    [self setSubviewsFrame];
    [self setSubviewsData];
    self.backgroundColor = [UIColor whiteColor];
    [self.layer setCornerRadius:2];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = kLayerBorderColor;
   
}

- (void)setSubviewsData
{
    //地名
    _nmLabel.text = _detailFrameModel.model.name;
    _nmLabel.textColor = kTextFontColor;
    //数字
   // _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailFrameModel.model.i];
    _numberLabel.textColor = kNaviColor;
    _numberLabel.font = [UIFont systemFontOfSize:8.0];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    
    //距离
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",(_detailFrameModel.model.distance/1000)];
    NSLog(@"$$$$$%@",_distanceLabel.text);
    _distanceLabel.textColor = kTextFontColor;
    _distanceLabel.font = [UIFont systemFontOfSize:12.0];
    //图标
   // _imgView.image = [UIImage imageNamed:_detailFrameModel.model.icon];
    //地址
    _addressLabel.text = _detailFrameModel.model.address;//[NSString stringWithFormat:@"地址:%@",_detailFrameModel.model.address];
    _addressLabel.textColor = kTextFontColor;
    _addressLabel.font = font(14.0);
   // _addressLabel.numberOfLines = 2;
    //分割线
    _line.backgroundColor = kLineClor;
    //导航
    [_naviB setTitle:@"导航" forState:UIControlStateNormal];
    [_naviB setImage:[UIImage imageNamed:@"result_btn_navi"] forState:UIControlStateNormal];
    [_naviB setTitleColor:kTextFontColor forState:UIControlStateNormal];
    
       [_naviB addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _naviB.backgroundColor = [UIColor whiteColor];
    //详情
    [_deatailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [_deatailBtn setImage:[UIImage imageNamed:@"result_btn_detail"] forState:UIControlStateNormal];
    [_deatailBtn setTitleColor:kTextFontColor forState:UIControlStateNormal]
    ;
    _deatailBtn.backgroundColor = [UIColor whiteColor];
      [_deatailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _verticalLine.backgroundColor = kLineClor;
}
- (void)setSubviewsFrame
{
    _imgView.frame = _detailFrameModel.iconF;
    _nmLabel.frame = _detailFrameModel.nameF;
    _numberLabel.frame = _detailFrameModel.numberF;
    _distanceLabel.frame = _detailFrameModel.distanceF;
    _addressLabel.frame = _detailFrameModel.addressF;
    _line.frame = _detailFrameModel.lineF;
    _naviB.frame = _detailFrameModel.naviBtnF;
    _deatailBtn.frame = _detailFrameModel.detailBtnF;
    _verticalLine.frame = _detailFrameModel.verticalLineF;
    self.frame = CGRectMake(5, 5, kMainScreenSizeWidth-10, _detailFrameModel.viewH);
}

- (void)btnClick:(UIButton *)btn
{
    self.buttonC(btn,_detailFrameModel);
}

-(void)buttonOncellClickedBlock:(void(^)(UIButton *btn,DetailFrameModel *frameModel))buttonblock
{
    self.buttonC = buttonblock;
}

@end
