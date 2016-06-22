//
//  popView.m
//  eNavi
//
//  Created by zuotoujing on 16/4/26.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "popView.h"
#import "popButton.h"

@interface popView ()
@property (nonatomic, weak) UIImageView *topImgView;
@end

@implementation popView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        
    {
//        UIImageView *topImgView = [[UIImageView alloc] init];
//        topImgView.image = [UIImage imageNamed:@"layout_p_frame"];
//        [self addSubview:topImgView];
//        self.topImgView = topImgView;

        [self setBtnWithTitle:@"3D地图" imageName:@"btn_3Dmap_normal" selectImgName:@"btn_3Dmap_press"];
        [self setBtnWithTitle:@"分享地图" imageName:@"btn_share_normal" selectImgName:@"btn_share_press"];
        [self setBtnWithTitle:@"收藏的点" imageName:@"btn_collect_normal" selectImgName:@"btn_collect_press"];
        [self setBtnWithTitle:@"卫星云图" imageName:@"btn_collect_normal" selectImgName:@"btn_collect_press"];
        [self setBtnWithTitle:@"清空地图" imageName:@"btn_delete_normal" selectImgName:@"btn_delete_press"];
    }
    return self;
}

- (UIButton *)setBtnWithTitle:(NSString *)title imageName:(NSString *)imageName selectImgName:(NSString *)selectName
{
    popButton  *btn = [[popButton alloc] init];
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectName] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    return btn;
}

- (void)layoutSubviews
{
    int btnCount = (int)self.subviews.count;
    int row = 2;
    int col = 3;
   // CGFloat btnH = self.height/row;
    //CGFloat btnW = self.width/col;
    for(int i=0;i<btnCount;i++)
    {
        popButton *btn = self.subviews[i];
        if (i/col==1)
        {
            btn.width = (self.width-0.5)/2;
        }
        else
        {
            btn.width = (self.width-1)/3;
        }
        btn.height = (self.height-0.5)/row;
        btn.x = (i%col)*(btn.width+0.5);
        btn.y = (i/col)*(btn.height+0.5);
    }
    
}

- (void)buttonClick:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(sendButtonOnPopView:)])
    {
        [_delegate sendButtonOnPopView:btn];
    }
}
@end
