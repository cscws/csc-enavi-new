//
//  BottomView.m
//  eNavi
//
//  Created by zuotoujing on 16/3/18.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "BottomView.h"
#import "bottomModel.h"
@interface BottomView ()
@property (nonatomic,weak)UIButton *beginNaviBtn;
@property (nonatomic,weak)UIButton *detailBtn;
@property (nonatomic,weak)UIButton *preBtn;
@property (nonatomic,weak)UIButton *nextBtn;
@property (nonatomic,weak)UIButton *jamBtn;

@property (nonatomic,weak)UILabel *startLabel;
@property (nonatomic,weak)UILabel *endLabel;
@property (nonatomic,weak)UILabel *routeType;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UILabel *distanceLabel;

@end
@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        
    {
        
        self.layer.borderWidth=1;
        self.layer.borderColor = kLayerBorderColor;
        
        UIButton *beginNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        beginNaviBtn.tag = 50;
        [beginNaviBtn setTitle:@"开始导航" forState:UIControlStateNormal];
        [beginNaviBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtn:beginNaviBtn imageName:@"btn_navi_start" highLightName:@"btn_navi_start"];
        beginNaviBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:beginNaviBtn];
        self.beginNaviBtn = beginNaviBtn;
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.tag = 51;
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        detailBtn.backgroundColor = [UIColor whiteColor];
        [self setBtn:detailBtn imageName:@"result_btn_detail" highLightName:@"result_btn_detail"];
        [self addSubview:detailBtn];
        self.detailBtn = detailBtn;
        
       UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        preBtn.tag = 52;
        [preBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtn:preBtn imageName:@"btn_left_n" highLightName:@"btn_left_p"];
        preBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:preBtn];
        self.preBtn = preBtn;
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.tag = 53;
        [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtn:nextBtn imageName:@"btn_right_n" highLightName:@"btn_right_p"];
        nextBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
        
        UIButton *jamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jamBtn.tag = 54;
        jamBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [jamBtn setTitle:@"躲避拥堵" forState:UIControlStateNormal];
        jamBtn.titleLabel.numberOfLines = 2;
        jamBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [jamBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtn:jamBtn imageName:@"btn_choose_off" highLightName:@"btn_choose_on"];
        [jamBtn setImage:[UIImage imageNamed:@"btn_choose_on"] forState:UIControlStateSelected];
        jamBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:jamBtn];
        self.jamBtn = jamBtn;

        UILabel *startLabel = [[UILabel alloc] init];
        startLabel.backgroundColor = [UIColor whiteColor];
        self.startLabel = startLabel;
        [self addSubview:_startLabel];
        
        UILabel *endLabel = [[UILabel alloc] init];
        endLabel.backgroundColor = [UIColor whiteColor];
        self.endLabel = endLabel;
        [self addSubview:_endLabel];
        
        UILabel *routeType = [[UILabel alloc] init];
        routeType.backgroundColor = [UIColor whiteColor];
        
        self.routeType = routeType;
        
        [self addSubview:_routeType];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor whiteColor];
        self.timeLabel = timeLabel;
        
        [self addSubview:_timeLabel];
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.backgroundColor = [UIColor whiteColor];
        self.distanceLabel = distanceLabel;
        [self addSubview:_distanceLabel];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    if(btn.tag==54)
    {
    _jamBtn.selected = !_jamBtn.selected;
    }
    
    if ([_delegate respondsToSelector:@selector(changeRoutePlanWithTag:)])
    {
        [_delegate changeRoutePlanWithTag:(int)btn.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = kLineClor;

    __weak __typeof(self) weakSelf = self;
    
    [weakSelf.preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(weakSelf);
        //make.left.mas_equalTo(weakSelf);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(60);
    }];
    
    [weakSelf.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.preBtn);
        make.left.mas_equalTo(weakSelf.preBtn.mas_right).offset(1);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-79);
        make.height.mas_equalTo(weakSelf.preBtn).multipliedBy(0.5);
    }];
    
    [weakSelf.routeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.startLabel.mas_bottom);
        make.left.mas_equalTo(weakSelf.preBtn.mas_right).offset(1);
        make.width.mas_equalTo(weakSelf.startLabel).multipliedBy(0.4);
        make.height.mas_equalTo(weakSelf.preBtn).multipliedBy(0.5);
    }];
    
    [weakSelf.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(weakSelf.routeType);
        make.left.mas_equalTo(weakSelf.routeType.mas_right).offset(-5);
        make.right.mas_equalTo(weakSelf.startLabel);
       
       
    }];
    
    [weakSelf.jamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.distanceLabel.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(weakSelf.preBtn);
    }];
    
    [weakSelf.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.jamBtn.mas_right).offset(1);
        make.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.preBtn);
    }];
    
    [weakSelf.beginNaviBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.top.mas_equalTo(weakSelf.routeType.mas_bottom).offset(1);
        make.left.mas_equalTo(weakSelf);
      //  make.right.mas_equalTo(weakSelf.detailBtn.mas_left).offset(-1);
        make.width.mas_equalTo(weakSelf).multipliedBy(0.6666);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        
    }];
    
    [weakSelf.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.beginNaviBtn);
        make.left.mas_equalTo(weakSelf.beginNaviBtn.mas_right).offset(1);
        make.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.beginNaviBtn);
    }];
    
//    _beginNaviBtn.frame = CGRectMake(0, 60, self.frame.size.width/1.3, 30);
//    
//    CGFloat detailX = CGRectGetMaxX(_beginNaviBtn.frame);
//    CGFloat detailW = self.frame.size.width-_beginNaviBtn.frame.size.width;
//    _detailBtn.frame = CGRectMake(detailX, 60, detailW, 30);
//    _preBtn.frame = CGRectMake(0, 0, 30, 60);
//    
//    _nextBtn.frame = CGRectMake(self.frame.size.width-30, 0, 30, 60);
//    
//
//    _jamBtn.frame = CGRectMake(self.frame.size.width-80, 0, 50, 60);
//    
//
//    _startLabel.frame = CGRectMake(30.5, 0, self.frame.size.width-119, 30);
//    
//    _routeType.frame = CGRectMake(30.5, 30, (self.frame.size.width-110)/2.5, 30);
//    
//    CGFloat distanX = CGRectGetMaxX(_routeType.frame);
//    CGFloat distanW = CGRectGetWidth(_routeType.frame);
//    _distanceLabel.frame = CGRectMake(distanX, 30, self.frame.size.width-117-distanW, 30);
//    _distanceLabel.font = font(13.0);

}

- (void)setBtn:(UIButton *)btn imageName:(NSString *)nomalName highLightName:(NSString *)highLightName
{
 [btn setImage:[UIImage imageNamed:nomalName] forState:UIControlStateNormal];
 [btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
  [btn setImage:[UIImage imageNamed:highLightName] forState:UIControlStateHighlighted];
}

- (void)setModel:(bottomModel *)model
{
    _model = model;
    _startLabel.text = [NSString stringWithFormat:@"%@>>%@",model.startLabel,model.endLabel];
    _startLabel.textColor = kTextFontColor;
    [_beginNaviBtn setTitleColor:kColor(77, 177, 232, 1) forState:UIControlStateNormal];
    _routeType.text = model.routeType;
    _routeType.textColor = [UIColor orangeColor];

    _distanceLabel.text = [NSString stringWithFormat:@"%@--%@",model.distanceLabel,model.timeLabel];
    _distanceLabel.font = font(14.0);
    _distanceLabel.textAlignment = NSTextAlignmentLeft;
    _distanceLabel.textColor = kTextFontColor;

}

@end
