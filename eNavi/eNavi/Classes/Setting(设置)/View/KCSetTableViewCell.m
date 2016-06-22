//
//  KCSetTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/6/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSetTableViewCell.h"
#import "KCSetModel.h"
#import "KCSetButtonModel.h"
#import "KCSetArrowItemModel.h"
#import "KCSetTitleArrowModel.h"
#import "KCSetFirstSectionModel.h"

@interface KCSetTableViewCell ()
@property (nonatomic, weak) UILabel *titltLabel;
@property (nonatomic, weak) UIButton *itemButton;
@property (nonatomic ,strong)UIImageView *arrowImg;

@end

@implementation KCSetTableViewCell

//- (UIButton *)itemButton
//{
//    if(_itemButton==nil)
//    {
//        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    }
//    return _itemButton;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)arrowImg
{
    if (_arrowImg == nil)
    {
        _arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_grey"]];
    }
    return _arrowImg;
}


- (void)setModel:(KCSetModel *)model
{

    _model = model;
    _titltLabel.text = model.title;
    _titltLabel.frame = CGRectMake(20, 5, 200, 30);
    _titltLabel.font = font(14.0);
    _titltLabel.textColor = kTextFontColor;

    if ([model isKindOfClass:[KCSetButtonModel class]])
    {
    
        switch (model.index) {
            case 0:
                [self itemBtn:_itemButton imgName:@"btn_set_2D"];
                break;
            case 1:
                [self itemBtn:_itemButton imgName:@"btn_set_off"];
                break;
            case 2:
                [self itemBtn:_itemButton imgName:@"btn_set_off"];
                break;
            case 3:
                [self itemBtn:_itemButton imgName:@"btn_set_auto"];
                break;
            case 4:
                [self itemBtn:_itemButton imgName:@"btn_set_bkg"];
                break;
            default:
                break;
        }        
    }

    else if ([model isKindOfClass:[KCSetArrowItemModel class]])
    {
        
        self.accessoryView = self.arrowImg;
    }
    else
    {
        self.accessoryView = self.arrowImg;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    
    KCSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[KCSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *title = [[UILabel alloc] init];
        _titltLabel = title;
        [self.contentView addSubview:title];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemButton = button;
        [self.contentView addSubview:button];
    
    }
    return self;
}

- (void)itemBtn:(UIButton *)btn imgName:(NSString *)imgName
{
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.x = kMainScreenSizeWidth-63;
    btn.y = 10;
    btn.size = _itemButton.currentBackgroundImage.size;
    if(_model.index == 4)
    {
        [btn setTitle:@"标准" forState:UIControlStateNormal];
        btn.titleLabel.font = font(14.0);
    }
    
    if((_model.index==0) || (_model.index==1) || (_model.index==2) )
    {
    [btn  addTarget:self action:@selector(twoStatusItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
    [btn  addTarget:self action:@selector(threeStatusItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/*NSString *str = [User objectForKey:@"mapDirection"];
 if([str isEqualToString:@"MapDirection_northUp"])
 {
 self.mapDirection = MapDirection_northUp;
 }else
 {
 self.mapDirection = MapDirection_random;
 }
 */

- (void)twoStatusItemBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(_model.index==0)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_3D"] forState:UIControlStateSelected];
    }else if (_model.index==1)
    {
        if(btn.selected==YES)
        {
            [User setObject:@"MapDirection_northUp" forKey:@"mapDirection"];
        }
        else
        {
            [User setObject:@"MapDirection_random" forKey:@"mapDirection"];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_on"] forState:UIControlStateSelected];
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_on"] forState:UIControlStateSelected];
    }
}

- (void)threeStatusItemBtnClicked:(UIButton *)btn
{
    if(_model.index==3)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_day"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dayMap:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btn setTitle:@"模式2" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(soundModelTwo:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)dayMap:(UIButton *)btn
{
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_night"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nightMap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nightMap:(UIButton *)btn
{
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_set_auto"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(threeStatusItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)soundModelTwo:(UIButton *)btn
{
    [btn setTitle:@"模式3" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(soundModelThree:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)soundModelThree:(UIButton *)btn
{
    [btn setTitle:@"标准" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(threeStatusItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
