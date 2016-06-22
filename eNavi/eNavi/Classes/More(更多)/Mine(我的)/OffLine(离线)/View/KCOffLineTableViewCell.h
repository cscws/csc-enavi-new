//
//  KCOffLineTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/16.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class downLoadModel,MBOfflineRecord;
typedef void(^detailBtnBlock)(MBOfflineRecord *offlineRecord,UIButton *btn);
@interface KCOffLineTableViewCell : UITableViewCell
@property (nonatomic, weak) UILabel *nmLabel;
@property (nonatomic, weak) UILabel *sizeLabel;
@property (nonatomic, weak) UILabel *progressLabel;
@property (nonatomic, weak) UIButton *downButton;
@property (nonatomic, weak) UIButton *PauseBtn;
@property (nonatomic, weak) UIButton *delegateBtn;
@property (nonatomic, copy) detailBtnBlock btnBlock;
@property(nonatomic, strong)downLoadModel *model;
- (void)btnOnCellClicked:(void(^)(MBOfflineRecord *offlineRecord,UIButton *btn))block;
+ (instancetype)cellWithTableview:(UITableView *)tableview;
@end
