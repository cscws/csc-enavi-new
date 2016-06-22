//
//  BusLineTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/3/28.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "BusLineTableViewCell.h"

@implementation BusLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableview:(UITableView *)tableview
{
static NSString *ID = @"busline";
    BusLineTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell = [[BusLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
