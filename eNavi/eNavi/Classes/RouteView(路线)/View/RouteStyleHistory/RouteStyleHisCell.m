//
//  RouteStyleHisCell.m
//  eNavi
//
//  Created by zuotoujing on 16/5/12.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "RouteStyleHisCell.h"
#import "RouteStyleHisModel.h"

typedef void(^btnOnCellClicked)(RouteStyleHisModel *);

@interface RouteStyleHisCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nmLabel;
@property (nonatomic, weak) UIButton *arrowBtn;
@property (nonatomic, weak) UILabel *lineOne;
@property (nonatomic, weak) UILabel *lineTwo;
@property (nonatomic, copy) btnOnCellClicked btnClick;
@end

@implementation RouteStyleHisCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"btnTypeStyle";
    RouteStyleHisCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[RouteStyleHisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIImageView *icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        self.iconView = icon;
        
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        self.nmLabel = label;
        
        UILabel *lineone = [[UILabel alloc] init];
        [self.contentView addSubview:lineone];
        self.lineOne = lineone;
        
        UILabel *linetwo = [[UILabel alloc] init];
        [self.contentView addSubview:linetwo];
        self.lineTwo = linetwo;
        
        UIButton *arrow = [[UIButton alloc] init];
        [self.contentView addSubview:arrow];
        self.arrowBtn = arrow;
    }
    return self;
}

- (void)setModel:(RouteStyleHisModel *)model
{
    _model = model;
    _nmLabel.text = [NSString stringWithFormat:@"%@->%@",model.startName,model.endName];
    _nmLabel.font = font(15.0);
    
    if([model.btnType isEqualToString:@"JC"])
    {
        _iconView.image = [UIImage imageNamed:@"btn_car_n"];
    }
    else if ([model.btnType isEqualToString:@"GJ"])
    {
    _iconView.image = [UIImage imageNamed:@"btn_bus_n"];
    }
    else if ([model.btnType isEqualToString:@"BX"])
    {
        _iconView.image = [UIImage imageNamed:@"btn_walk_n"];
    }
    
    [_arrowBtn setBackgroundImage:[UIImage imageNamed:@"btn_detail_arrrow"] forState:UIControlStateNormal];
    _lineOne.backgroundColor = kLineClor;
    _lineTwo.backgroundColor = kLineClor;
    _iconView.frame = CGRectMake(5, 0, 40, 40);
    _lineOne.frame  = CGRectMake(45, 5, 1, 30);
    _nmLabel.frame = CGRectMake(50, 0, 251, 40);
    _lineTwo.frame = CGRectMake(kMainScreenSizeWidth-61, 5, 1, 30);
    _arrowBtn.frame = CGRectMake(kMainScreenSizeWidth-50, 5, 30, 30);
    [_arrowBtn addTarget:self action:@selector(arrowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)arrowBtnClicked:(UIButton *)arrowBtn
{
    self.btnClick(_model);
}

- (void)buttonOnCellClicked:(void(^)(RouteStyleHisModel *model))block
{
    self.btnClick = block;
}

@end
