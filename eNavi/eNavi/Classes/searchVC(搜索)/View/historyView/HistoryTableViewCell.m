//
//  HistoryTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/3/30.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "historyModel.h"
@implementation HistoryTableViewCell

- (void)setModel:(historyModel *)model
{
    _model = model;
    self.textLabel.text = model.name;
    self.textLabel.textColor = kTextFontColor;
    self.textLabel.font = font(14.0);
    self.imageView.image = [UIImage imageNamed:@"history"];
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detail_arrrow"]];
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
