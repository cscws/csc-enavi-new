//
//  HeaderView.h
//  eNavi
//
//  Created by zuotoujing on 16/3/15.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView,ProvinceModel;
@protocol HeaderViewDelegate <NSObject>
- (void)headerViewbtnDidClicked:(HeaderView *)header;

@end
@interface HeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong)ProvinceModel *pModel;
@property (nonatomic, strong) UIImageView *upImg;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, weak) id<HeaderViewDelegate> delegate;
//+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
