//
//  KCOffenView.m
//  eNavi
//
//  Created by zuotoujing on 16/5/26.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCOffenView.h"

@interface KCOffenView ()
@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) UIButton *homeArrowBtn;

@property (nonatomic, weak) UIButton *companyArrowBtn;
@property (nonatomic, weak) UIButton *compButton;
@property (nonatomic, weak) UIButton *homeButton;
@end

@implementation KCOffenView
- (instancetype)initWithFrame:(CGRect)frame
{
if(self=[super initWithFrame:frame])
{
    UIView *line = [[UIView alloc] init];
    //CGRectMake(0, offenView.frame.size.height/2, offenView.frame.size.width, 1)
    self.line = line;
    line.backgroundColor = kLineClor;
    [self addSubview:line];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setImage:[UIImage imageNamed:@"btn_home"] forState:UIControlStateNormal];
    // homeButton.backgroundColor = [UIColor redColor];
    [homeButton setTitle:@"回家" forState:UIControlStateNormal];
    homeButton.titleLabel.font = font(17.0);
    [homeButton setTitleColor:kTextFontColor forState:UIControlStateNormal];
    homeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    homeButton.titleEdgeInsets = UIEdgeInsetsMake(3, 15, 0, 0);
  //  homeButton.frame = CGRectMake(0, 0, 100, offenView.frame.size.height/2);
    [homeButton setUserInteractionEnabled:NO];
    self.homeButton = homeButton;
    [self addSubview:homeButton];
    
    UIButton *homeNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[homeNameBtn setTitle:@"绿地香颂" forState:UIControlStateNormal];
    [homeNameBtn setTitle:[User objectForKey:@"homePoiName"] forState:UIControlStateNormal];
    homeNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    [homeNameBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    // homeNameBtn.backgroundColor =[ UIColor blueColor];
    homeNameBtn.tag = 15;
    [homeNameBtn addTarget:self action:@selector(btnOnOffenViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    homeNameBtn.titleLabel.font = font(14.0);
    self.homeNameBtn = homeNameBtn;
    [self addSubview:homeNameBtn];
    
    UIButton *homeArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeArrowBtn addTarget:self action:@selector(btnOnOffenViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    homeArrowBtn.tag = 14;
    [homeArrowBtn setImage:[UIImage imageNamed:@"btn_detail_arrrow"] forState:UIControlStateNormal];
    self.homeArrowBtn = homeArrowBtn;
    [self addSubview:homeArrowBtn];
    
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [compButton setImage:[UIImage imageNamed:@"btn_company"] forState:UIControlStateNormal];
    [compButton setTitle:@"去公司" forState:UIControlStateNormal];
    compButton.titleLabel.font = font(17.0);
    [compButton setTitleColor:kTextFontColor forState:UIControlStateNormal];
    [compButton setUserInteractionEnabled:NO];
    compButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.compButton = compButton;
    [self addSubview:compButton];
    
    UIButton *companyNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyNameBtn setTitle:[User objectForKey:@"companyPoiName"] forState:UIControlStateNormal];
    companyNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    [companyNameBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    companyNameBtn.tag = 16;
    [companyNameBtn addTarget:self action:@selector(btnOnOffenViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    companyNameBtn.titleLabel.font = font(14.0);
    self.companyNameBtn = companyNameBtn;
    [self addSubview:companyNameBtn];
    
    UIButton *companyArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyArrowBtn addTarget:self action:@selector(btnOnOffenViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    companyArrowBtn.tag = 17;
    [companyArrowBtn setImage:[UIImage imageNamed:@"btn_detail_arrrow"] forState:UIControlStateNormal];
    self.companyArrowBtn = companyArrowBtn;
    [self addSubview:companyArrowBtn];
}
    
    return self;
}

- (void)layoutSubviews
{

    _line.frame = CGRectMake(0, self.height/2, self.width, 1);
    _homeButton.frame = CGRectMake(0, 0, 100, self.height/2);
    _homeNameBtn.frame = CGRectMake(0, 0, self.width-50, self.height/2);
    CGFloat homeArrowBtnX = CGRectGetMaxX(_homeNameBtn.frame);
    _homeArrowBtn.frame = CGRectMake(homeArrowBtnX, 0, 50, self.height/2);
    
    _compButton.frame = CGRectMake(0, self.height/2, 100, self.height/2);

    _companyNameBtn.frame = CGRectMake(0, self.height/2, self.width-50, self.height/2);
    _companyArrowBtn.frame = CGRectMake(homeArrowBtnX, self.height/2, 50, self.height/2);
}

- (void)btnOnOffenViewClicked:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(sendBtnOneOfenView:)])
    {
        [_delegate sendBtnOneOfenView:btn];
    }
}

@end
