//
//  RouteDetailTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/4/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "RouteDetailTableViewCell.h"

@interface RouteDetailTableViewCell ()
@property (nonatomic ,weak) UIImageView *imgV;
@property (nonatomic ,weak) UILabel *titleLabel;
@end
@implementation RouteDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mine";
    
    RouteDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        
        cell = [[RouteDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];
        CGFloat nmLabelX = CGRectGetMaxX(imageV.frame);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nmLabelX, 0, 100, 40)];
        _imgV = imageV;
        _titleLabel = titleLabel;
        [self.contentView addSubview:_imgV];
        [self.contentView addSubview:_titleLabel];
   
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
