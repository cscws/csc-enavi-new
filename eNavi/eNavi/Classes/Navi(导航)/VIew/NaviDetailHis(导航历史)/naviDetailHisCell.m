//
//  naviDetailHisCell.m
//  eNavi
//
//  Created by zuotoujing on 16/5/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "naviDetailHisCell.h"
#import "NaviDetailHisModel.h"

typedef void(^detailBtnBlock)(NaviDetailHisModel *model);
@interface naviDetailHisCell ()
@property (nonatomic, weak) UILabel *nmLabel;
@property (nonatomic, weak) UILabel *adressLabel;
@property (nonatomic, weak) UIButton *detailButton;
@property (nonatomic, copy) detailBtnBlock btnBlock;
@property (nonatomic, weak) UILabel *line;
@end

@implementation naviDetailHisCell
+ (instancetype)cellWithTableview:(UITableView *)tableview
{
    static NSString *ID = @"naviDetailHis";
    naviDetailHisCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[naviDetailHisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *nmLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nmLabel];
        self.nmLabel = nmLabel;
        
        UILabel *adressLabel = [[UILabel alloc] init];
        [self.contentView addSubview:adressLabel];
        self.adressLabel = adressLabel;
        
        UILabel *line = [[UILabel alloc] init];
        [self.contentView addSubview:line];
        self.line = line;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        self.detailButton = button;
    }
    
    return self;
}

- (void)setModel:(NaviDetailHisModel *)model
{
    _model = model;
    _nmLabel.text = model.name;
    _adressLabel.text = model.adress;
    _adressLabel.font = font(14.0);
    _nmLabel.frame = CGRectMake(5, 0, 220, 30);
    _adressLabel.frame = CGRectMake(5, 30, 260, 15);
    CGFloat lineX = kMainScreenSizeWidth-51;
    _line.frame = CGRectMake(lineX, 5, 1, 40);
    _line.backgroundColor = kLineClor;
    
    CGFloat detailBtnX = CGRectGetMaxX(_line.frame)+5;
    _detailButton.frame = CGRectMake(detailBtnX, 10, 30, 30);
    //_detailButton.backgroundColor = [UIColor redColor];
    [_detailButton setImage:[UIImage imageNamed:@"result_btn_detail"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)detailBtnClicked:(UIButton *)sender
{
    self.btnBlock(_model);
}

- (void)btnOnCellClicked:(void(^)(NaviDetailHisModel *model))block
{
    self.btnBlock = block;
}

@end
