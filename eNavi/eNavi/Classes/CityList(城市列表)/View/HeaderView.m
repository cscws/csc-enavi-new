//
//  HeaderView.m
//  eNavi
//
//  Created by zuotoujing on 16/3/15.
//  Copyright © 2016年 csc. All rights reserved.
//
#import "HeaderView.h"
#import "ProvinceModel.h"
#import "HeaderCityBtn.h"
@interface HeaderView ()

@end

@implementation HeaderView
//+ (instancetype)headerViewWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"header";
//    HeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
//    if (headerView == nil)
//    {
//        headerView = [[HeaderView alloc] initWithReuseIdentifier:ID];
//    }
//    return headerView;
//}
//
//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
//{
//    
//    self = [super initWithReuseIdentifier:reuseIdentifier];
//    if (self)
//    {
//        //        1.添加子控件
//        // 1.1添加按钮
//        HeaderCityBtn *btn = [HeaderCityBtn buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor colorWithRed:104/255 green:112/255 blue:120/255 alpha:0.1];
//        // 监听按钮的点击事件
//        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        // 2.设置按钮的内边距,然按钮的内容距离左边有一定的距离
//        //CGFloat conyentY = CGRectGetMaxX(self.frame);
//      //  btn.contentEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
//        [btn setTitleColor:[UIColor colorWithRed:104/255 green:112/255 blue:120/255 alpha:0.7] forState:UIControlStateNormal];
//        // 设置btn中的图片不填充整个imageview
//        btn.imageView.contentMode = UIViewContentModeCenter;
//        // 超出范围的图片不要剪切
//        //        btn.imageView.clipsToBounds = NO;
//        btn.imageView.layer.masksToBounds = NO;
//        
//        [self addSubview:btn];
//        self.btn = btn;
//        
//       
//    }
//    
//
//    return  self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

    HeaderCityBtn *btn = [HeaderCityBtn buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
    //btn.backgroundColor = [UIColor colorWithRed:104/255 green:112/255 blue:120/255 alpha:0.1];
    // 监听按钮的点击事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 2.设置按钮的内边距,然按钮的内容距离左边有一定的距离
    //CGFloat conyentY = CGRectGetMaxX(self.frame);
    //  btn.contentEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    [btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    // 设置btn中的图片不填充整个imageview
    btn.imageView.contentMode = UIViewContentModeCenter;
    // 超出范围的图片不要剪切
    //        btn.imageView.clipsToBounds = NO;
    btn.imageView.layer.masksToBounds = NO;
    
    [self addSubview:btn];
    self.btn = btn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    1.设置按钮的frame
    self.btn.frame = self.bounds;
    
}

- (void)setPModel:(ProvinceModel *)pModel
{
    _pModel = pModel;

    [self.btn setTitle:pModel.Pname forState:UIControlStateNormal];
    
   // self.upImg.image = [UIImage imageNamed:@"btn_detail"];
}

- (void)didMoveToSuperview
{
if (self.pModel.isOPen) {
    self.btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}
}

- (void)btnOnClick:(UIButton *)btn
{
    self.pModel.Open = !self.pModel.isOPen;

        if ([self.delegate respondsToSelector:@selector(headerViewbtnDidClicked:)])
    {
        [self.delegate headerViewbtnDidClicked:self];
    }
}

@end
