//
//  DetailSearchTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "DetailSearchTableViewCell.h"


@interface DetailSearchTableViewCell()

@end
@implementation DetailSearchTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DetailSearchTableViewCell";
    
    DetailSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[DetailSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        BackView *back = [[BackView alloc] init];
        self.backView = back;
        [self.contentView addSubview:back];
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
