//
//  moreTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/3/8.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "moreTableViewCell.h"
#import "KCItemModel.h"
#import "KCitemArrow.h"
#import "KCitemSwitch.h"

@interface moreTableViewCell ()

{
    UILabel     *_nmLabel;
    UILabel     *_scmLabel;
    UILabel     *_starLabel;
    UILabel     *_wishLabel;
    UILabel     *_vid;
    UIImageView *_image;
    UIButton    *_btn;
    
}

@property (nonatomic ,strong)UIImageView *downImg;
@property (nonatomic ,strong)UIImageView *arrowImg;

@end

@implementation moreTableViewCell

- (void)awakeFromNib {
}


- (UIImageView *)downImg
{
    if (_downImg == nil)
    {
        _downImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downloade"]];
    }
    return _downImg;
}

- (UIImageView *)arrowImg
{
    if (_arrowImg == nil)
    {
        _arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_grey"]];
    }
    return _arrowImg;
}

- (void)setModel:(KCItemModel *)model
{
    _model = model;
    _nmLabel.text = model.title;
    [_nmLabel setFont:font(14.0)];
    _nmLabel.textColor = kTextFontColor;
    _image.image = [UIImage imageNamed:model.icon];
    if ([model isKindOfClass:[KCitemArrow class]])
    {
        self.accessoryView = self.arrowImg;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if ([model isKindOfClass:[KCitemSwitch class]])
    {
        self.accessoryView = self.downImg;
       // self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downloade"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
    self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mine";
    
    moreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {        
        cell = [[moreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];        
        CGFloat nmLabelX = CGRectGetMaxX(_image.frame);
        _nmLabel = [[UILabel alloc] initWithFrame:CGRectMake(nmLabelX, 0, 100, 40)];
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_nmLabel];
        
    }
    return self;
}


@end
