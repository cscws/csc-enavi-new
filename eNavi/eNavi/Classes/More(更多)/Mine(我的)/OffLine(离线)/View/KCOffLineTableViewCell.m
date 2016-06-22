//
//  KCOffLineTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/5/16.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCOffLineTableViewCell.h"
#import <iNaviCore/MBOfflineDataManager.h>
#import "downLoadModel.h"

@implementation KCOffLineTableViewCell
+ (instancetype)cellWithTableview:(UITableView *)tableview
{
    static NSString *ID = @"naviDetailHis";
    KCOffLineTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[KCOffLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *nmlabel = [[UILabel alloc] init];
        [self.contentView addSubview:nmlabel];
        self.nmLabel = nmlabel;
        
        UILabel *sizelabel = [[UILabel alloc] init];
        [self.contentView addSubview:sizelabel];
        self.sizeLabel = sizelabel;
        
        UILabel *progresslabel = [[UILabel alloc] init];
        [self.contentView addSubview:progresslabel];
        self.progressLabel = progresslabel;
        
        UIButton *downbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:downbtn];
        self.downButton = downbtn;
        
        UIButton *PauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:PauseBtn];
        self.PauseBtn = PauseBtn;
        
        UIButton *delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:delegateBtn];
        self.delegateBtn = delegateBtn;
        
    }
    
    return self;
}

- (void)setModel:(downLoadModel *)model
{
    _model = model;
    [self setSubviewData];
    [self setSubViewFrame];
   
}

- (void)setSubviewData
{
    if (_model.offlineRecord.type == DataType_Vip) {
        _nmLabel.text = @"导航数据";
    }else if(_model.offlineRecord.type == DataType_Normal){
        _nmLabel.text = @"免费数据";
    }else if(_model.offlineRecord.type == DataType_Base){
        _nmLabel.text = @"基础数据包";
    }else if(_model.offlineRecord.type == DataType_Camera){
        _nmLabel.text= @"增强电子眼";
    }
    _sizeLabel.text = [NSString stringWithFormat:@"%.1fMB",_model.offlineRecord.fileSize/1024.0/1024.0];
    [_downButton setImage:[UIImage imageNamed:@"downloade"] forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _downButton.tag = 40;
    [_PauseBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _PauseBtn.tag = 41;
    [_delegateBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_delegateBtn setImage:[UIImage imageNamed:@"btn_delete_press"] forState:UIControlStateNormal];
    _delegateBtn.tag = 42;
}

- (void)setSubViewFrame
{
    _nmLabel.frame = CGRectMake(5, 0, 200, 30);
    _sizeLabel.frame = CGRectMake(5, 30, 200, 30);
    _downButton.frame = CGRectMake(kMainScreenSizeWidth-50, 15, 30, 30);
//    _PauseBtn.frame = CGRectMake(kMainScreenSizeWidth-50, 15, 30, 30);
    _delegateBtn.frame = CGRectMake(kMainScreenSizeWidth-50, 15, 30, 30);
    _progressLabel.frame = CGRectMake(kMainScreenSizeWidth-100, 15, 90, 30);
    _progressLabel.font = font(12.0);
    _progressLabel.textColor = kTextFontColor;
    _progressLabel.textAlignment = NSTextAlignmentLeft;
    _PauseBtn.backgroundColor = [UIColor redColor];
//    _PauseBtn.hidden = YES;
    _sizeLabel.font = font(14.0);
    _nmLabel.textColor = kTextFontColor;
    _sizeLabel.textColor = kTextFontColor;
}

- (void)downBtnClicked:(UIButton *)sender
{
    self.btnBlock(_model.offlineRecord,sender);
}

- (void)btnOnCellClicked:(void(^)(MBOfflineRecord *offlineRecord, UIButton *btn))block
{
    self.btnBlock = block;
}


@end
