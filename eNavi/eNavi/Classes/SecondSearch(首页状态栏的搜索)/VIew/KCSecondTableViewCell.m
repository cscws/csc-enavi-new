//
//  KCSecondTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/5/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSecondTableViewCell.h"
#import "historyModel.h"

typedef void(^buttonClicked)(NSString *);
@interface KCSecondTableViewCell ()
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *nmLabel;
@property (nonatomic, weak) UIButton *arrowBtn;
@property (nonatomic, copy) buttonClicked buttonClick;
@end
@implementation KCSecondTableViewCell
+ (instancetype)cellWithtableView:(UITableView *)tableview
{
    static NSString *ID = @"secondsearch";
    KCSecondTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[KCSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        UILabel *nmLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nmLabel];
        self.nmLabel = nmLabel;
        
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:arrowBtn];
        self.arrowBtn = arrowBtn;
        
    }
    return self;
}

- (void)setModel:(historyModel *)model
{
    _model = model;
    _imgView.image = [UIImage imageNamed:@"history"];
    _imgView.frame = CGRectMake(5, 5, 30, 30);
   // _imgView.backgroundColor = [UIColor redColor];
    _nmLabel.frame = CGRectMake(35, 5, 251, 30);
    _nmLabel.text = model.name;
    _nmLabel.font = font(14.0);
    _nmLabel.textColor = kTextFontColor;
   // _nmLabel.backgroundColor = [UIColor blueColor];
    _arrowBtn.frame = CGRectMake(kMainScreenSizeWidth-40, 5, 30, 30);
    [_arrowBtn setImage:[UIImage imageNamed:@"btn_detail_arrrow"] forState:UIControlStateNormal];
    [_arrowBtn addTarget: self action:@selector(btnOnCellClicked:) forControlEvents:UIControlEventTouchDown];
   // _arrowBtn.backgroundColor = [UIColor cyanColor];
    
}

- (void)btnOnCellClicked:(UIButton *)button
{
    self.buttonClick(_nmLabel.text);
}

- (void)buttonOnCellClicked:(void(^)(NSString *str))block
{
    self.buttonClick = block;
}

@end
