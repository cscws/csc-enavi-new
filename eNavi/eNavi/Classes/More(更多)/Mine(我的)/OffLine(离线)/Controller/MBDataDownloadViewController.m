//
//  DetailSearchTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "MBDataDownloadViewController.h"
#import <iNaviCore/MBAuth.h>
#import "KCOffLineTableViewCell.h"

#import "downLoadModel.h"
@interface MBDataDownloadViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, weak) UITableView *downLoadTableView;
@end


@implementation MBDataDownloadViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    [self createTableView];
    _dictionary = [NSMutableDictionary dictionary];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = self;
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = nil;
    [super viewDidDisappear:animated];
}

- (void)setNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, 64)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
    imgView.image = [UIImage imageNamed:@"top_bkg"];
    [view addSubview:imgView];
    [self.view addSubview:view];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //CGFloat btnY = (CGRectGetMaxY(view.frame)-30)/2;
    backBtn.frame = CGRectMake(0, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    CGFloat searchW = CGRectGetWidth(backBtn.frame);
    CGFloat searchX = CGRectGetMaxX(backBtn.frame);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(searchX, 29, view.frame.size.width-2*searchW-5, 30);
    titleLabel.text = _titleName;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}

- (void)createTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 69, kMainScreenSizeWidth-10, kMainScreenSizeHeight-69)];
    self.downLoadTableView = tableView;
    tableView.backgroundColor = kVCViewcolor;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView.layer setMasksToBounds:YES];
    [tableView.layer setCornerRadius:2];
    tableView.layer.borderWidth = 0.5;
    tableView.layer.borderColor = kLayerBorderColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
}

#pragma mark - PublicMethod
/**
 *  返回
 */
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBOfflineRecord* record = [self.dataArray objectAtIndex:indexPath.row];
    
    KCOffLineTableViewCell *cell = [KCOffLineTableViewCell cellWithTableview:tableView];
    
    [_dictionary setObject:cell forKey:record.dataId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    downLoadModel *model = [[downLoadModel alloc] init];
    model.offlineRecord = record;
    cell.model = model;
    
    if (record.download != DownloadState_Complete) {    // 数据未下载完
        cell.downButton.hidden = NO;
        cell.progressLabel.hidden = NO;
        cell.delegateBtn.hidden = YES;
    }else{
        if (record.isUpdate){
            cell.downButton.hidden = NO;
            cell.progressLabel.hidden = YES;
            cell.delegateBtn.hidden = YES;
        }
        else
        {
            cell.downButton.hidden = YES;
            cell.progressLabel.hidden = YES;
            cell.delegateBtn.hidden = NO;
        }
    }
    
    [cell btnOnCellClicked:^(MBOfflineRecord *offlineRecord, UIButton *btn) {
        if(btn.tag==40)
        {
            if (record.download != DownloadState_Complete) {    // 数据未下载完
                [[MBOfflineDataManager sharedOfflineDataManager] start:record];
                cell.downButton.hidden = YES;
                cell.progressLabel.hidden = NO;
                cell.progressLabel.text = [NSString stringWithFormat:@"等待中.."];
            }else{
                if (record.isUpdate){
                    [[MBOfflineDataManager sharedOfflineDataManager] start:record];
                }
                    else
                {
                    cell.downButton.hidden = YES;
                    cell.progressLabel.hidden = YES;
                    cell.delegateBtn.hidden = NO;
                }
            }
        }
        else if (btn.tag==41)
        {
            if (record.download != DownloadState_Pause){    // 当前不在暂停状态
                
                [[MBOfflineDataManager sharedOfflineDataManager] pause:record];
                
            }else{  // 当前在暂停状态
                
                [[MBOfflineDataManager sharedOfflineDataManager] start:record];
            }
        }
        else if (btn.tag==42)
        {
            cell.delegateBtn.hidden = YES;
            cell.downButton.hidden = NO;
        [[MBOfflineDataManager sharedOfflineDataManager] remove:record];
            
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - MBOfflineDataDelegate
/**
 *  下载离线数据状态跟踪
 */
- (void)onGetOfflineDataState:(MBOfflineRecord*)record{
    
     KCOffLineTableViewCell *cell = [_dictionary objectForKey:record.dataId];
    if (cell!=nil)
    {
    
        if (record.download == DownloadState_Downloading) { // 当前正在下载
            cell.progressLabel.text = [NSString stringWithFormat:@"正在下载:%lld%%",record.progress];
            cell.downButton.hidden = YES;
            cell.delegateBtn.hidden = YES;
            
        }else if(record.download == DownloadState_Start){   // 下载完成
          
        }else if(record.download == DownloadState_Complete){// 下载完成
            cell.delegateBtn.hidden = NO;
            cell.progressLabel.hidden = YES;
            if([[MBAuth sharedAuth] checkLicense] != MBAuthError_none){
                [[MBAuth sharedAuth] updateLicense];                
            }
            
        }else if(record.download == DownloadState_Error){   //  下载错误
            Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
            if ([r currentReachabilityStatus] == NotReachable) {    // 网络不可用
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"下载失败" message:@"无网络信号" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                if (record.download != DownloadState_Pause){
                    [[MBOfflineDataManager sharedOfflineDataManager] pause:record];
                    
                }
            }
            else{  // 网络可用
                // 开始下载离线数据
                [[MBOfflineDataManager sharedOfflineDataManager] start:record];
                
            }
        }
    }
}

- (void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //    self.dataArray = nil;
    //    [_dictionary removeAllObjects];
}

@end
