//
//  miShuView.m
//  eNavi
//
//  Created by zuotoujing on 16/5/23.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "miShuView.h"

@interface miShuView ()
@property (nonatomic, weak) UILabel *nmLabel;
@property (nonatomic, weak) UILabel *topLine;
@property (nonatomic, weak) UILabel *detailText;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIButton *callBtn;
@property (nonatomic, weak) UILabel *bottomLine;
@property (nonatomic, weak) UIButton *notiBtn;
@end
@implementation miShuView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UILabel *nmlabel = [[UILabel alloc] init];
        nmlabel.text = @"导航秘书";
        nmlabel.font = font(20.0);
        nmlabel.textAlignment = NSTextAlignmentCenter;
        nmlabel.textColor = [UIColor orangeColor];
        [self addSubview:nmlabel];
        self.nmLabel = nmlabel;
        
        UILabel *topLine = [[UILabel alloc] init];
        topLine.backgroundColor = kLineClor;
        [self addSubview:topLine];
        self.topLine = topLine;
        
        UILabel *detailText = [[UILabel alloc] init];
        detailText.text = [NSString stringWithFormat:@"%@\n\n%@",@"尊敬的用户,您好!导航秘书是拨打电话到客服中心,由中国电信客服人员为您代设目的地,自动完成导航的一项服务.",@"资费:只收取本地通讯费,无信息费."];
        detailText.font = font(16.0);
        [self addSubview:detailText];
        self.detailText = detailText;
        
        UIButton *sele = [UIButton buttonWithType:UIButtonTypeCustom];
        [sele setImage:[UIImage imageNamed:@"dont_remind"] forState:UIControlStateNormal];
        [sele setImage:[UIImage imageNamed:@"dont_remind_check"] forState:UIControlStateSelected];
        [sele setTitle:@"不再提醒" forState:UIControlStateNormal];
        [sele setTitleColor:kTextFontColor forState:UIControlStateNormal];
        sele.titleLabel.font = font(16.0);
        [sele addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sele];
        self.selectBtn = sele;
        
        UIButton *callbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callbtn setTitle:@"拨打" forState:UIControlStateNormal];
        callbtn.backgroundColor = kColor(76, 178, 232, 1);
        [callbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:callbtn];
        self.callBtn = callbtn;
        
        UILabel *bottomLine = [[UILabel alloc] init];
        bottomLine.backgroundColor = kLineClor;
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
        
        UIButton *noti = [UIButton buttonWithType:UIButtonTypeCustom];
        [noti setImage:[UIImage imageNamed:@"tip"] forState:UIControlStateNormal];
        [noti setTitle:@"提示:驾驶途中为了保证您的安全,请开启免提方式通话" forState:UIControlStateNormal];
        [noti setTitleColor:kTextFontColor forState:UIControlStateNormal];
        noti.titleLabel.font = font(16.0);
        noti.userInteractionEnabled = NO;
        [self addSubview:noti];
        self.notiBtn = noti;
    }
    return self;
}

- (void)layoutSubviews
{
    _nmLabel.frame = CGRectMake(0, 0, self.width, 50);
    
    CGFloat toplineY = CGRectGetMaxY(_nmLabel.frame);
    _topLine.frame = CGRectMake(5, toplineY, self.width-10, 1);
    
    CGFloat detailY = CGRectGetMaxY(_topLine.frame)+2;
    CGSize size = [_detailText.text sizeWithFont:font(16.0) maxSize:CGSizeMake(self.width-40,MAXFLOAT)];
    _detailText.frame = (CGRect){{20,detailY}, size};
    _detailText.numberOfLines = 0;
    
    CGFloat seleBtnY = CGRectGetMaxY(_detailText.frame);
    _selectBtn.frame = CGRectMake(0, seleBtnY, self.width, 40);
    
    CGFloat callbtnY = CGRectGetMaxY(_selectBtn.frame);
    _callBtn.frame = CGRectMake((self.width-80)/2, callbtnY, 80, 40);
    
    CGFloat bottomY = CGRectGetMaxY(_callBtn.frame)+10;
    _bottomLine.frame = CGRectMake(5, bottomY, self.width-10, 1);
    
    CGFloat notiY = CGRectGetMaxY(_bottomLine.frame)+10;
   CGSize btnSize = [_notiBtn.currentTitle sizeWithFont:font(16.0) maxSize:CGSizeMake(self.width-20,MAXFLOAT)];
    _notiBtn.titleLabel.numberOfLines = 0;
    _notiBtn.frame = (CGRect){{0, notiY}, btnSize};
    
}

- (void)buttonClick:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(sendButtonOnMishuView:)])
    {
        [_delegate sendButtonOnMishuView:btn];
    }
}

@end
