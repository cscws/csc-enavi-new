//
//  TabBarView.m
//  eNavi
//
//  Created by zuotoujing on 16/2/22.
//  Copyright © 2016年 zuotoujing. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        
    {
        [self setBtnWithTitle:@"导航" imageName:@"PLUS_btn_navi"];
        [self setBtnWithTitle:@"周边" imageName:@"PLUS_btn_circum"];
        [self setBtnWithTitle:@"路线" imageName:@"btn_rout"];
        [self setBtnWithTitle:@"我的" imageName:@"btn_mine"];
        
    }
    return self;
}

- (UIButton *)setBtnWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    btn.layer.borderWidth = 0.5;
//    btn.layer.borderColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1].CGColor;
    [self addSubview:btn];
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor grayColor];
//    [self addSubview:lineView];
    // 设置图片和文字
     [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    // 设置按钮选中的背景
//    [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected];
    
    // 设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置按钮的内容左对齐
   // btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 设置间距
   // btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
      btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    return btn;
}

- (void)layoutSubviews
{
    int btnCount = (int)self.subviews.count;
    CGFloat btnW = self.width/btnCount;
    CGFloat btnH = self.height;
    for(int i=0;i<btnCount;i++)
    {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
    }
}

- (void)buttonClick:(UIButton *)btn
{
    
    if ([_delegate respondsToSelector:@selector(tabBarView:pushToOtherVCWithBtnTag:)])
    {
        [_delegate tabBarView:self pushToOtherVCWithBtnTag:(int)btn.tag];
    }
//    if([_delegate respondsToSelector:@selector(leftMenu:fromBtnTag:toBtnTag:)])
//    {
//        [_delegate leftMenu:self fromBtnTag:(int)self.seleBtn.tag toBtnTag:(int)btn.tag];
//    }
//    
//    self.seleBtn.selected = NO;
//    btn.selected = YES;
//    self.seleBtn = btn;
}

//- (void)setDelegate:(id<TabBarDelegate>)delegate
//{
//    _delegate = delegate;
//    [self [self.subviews firstObject]];
//}

@end
