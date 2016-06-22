//
//  JZSearchBar.m
//  封装一个搜索框
//
//  Created by peijz on 16/1/8.
//  Copyright © 2016年 peijz. All rights reserved.
//

#import "JZSearchBar.h"
@implementation JZSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kLayerBorderColor;
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeAlways;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索关键字" attributes:dict];

    }
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
