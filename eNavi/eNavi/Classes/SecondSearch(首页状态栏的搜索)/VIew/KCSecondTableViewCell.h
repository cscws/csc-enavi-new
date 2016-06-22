//
//  KCSecondTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class historyModel;
@interface KCSecondTableViewCell : UITableViewCell
@property (nonatomic, strong)historyModel *model;
+ (instancetype)cellWithtableView:(UITableView *)tableview;
- (void)buttonOnCellClicked:(void(^)(NSString *))block;
@end
