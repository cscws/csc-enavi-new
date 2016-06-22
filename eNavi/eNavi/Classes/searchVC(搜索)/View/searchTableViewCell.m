//
//  searchTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "searchTableViewCell.h"
#import "DetailFrameModel.h"
#import "DetailModel.h"

@implementation searchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView andStr:(NSString *)str
{
   // int i = arc4random() % 100;
   //static NSString *ID = @"searchResult";
    
    searchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil)
    {
        cell = [[searchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        DetailView *view =[[DetailView alloc] init];
        [self.contentView addSubview:view];
        self.bgView = view;
    }
    
    return self;
}

@end
