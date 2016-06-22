//
//  MBDataDownloadViewController.m
//  iOSSDKDemo
//
//  Created by zhouxg on 15/6/18.
//  Copyright (c) 2015年 zhouxg. All rights reserved.
//

#import "MBDataDownloadViewController.h"
#import <iNaviCore/MBAuth.h>
//#import <iNaviCore/MBReachability.h>
#import "Reachability.h"

@interface MBDataDownloadViewController (){
    /**
     *  数据字典
     */
    NSMutableDictionary* _dictionary;
}

@end

@implementation MBDataDownloadViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    self.dataArray = nil;
//    [_dictionary removeAllObjects];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)viewDidAppear:(BOOL)animated{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = self;
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = nil;
    [super viewDidDisappear:animated];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MBOfflineRecord* record = [self.dataArray objectAtIndex:indexPath.row];
    
    [_dictionary setObject:cell forKey:record.dataId];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    if (record.type == DataType_Vip) {
        label.text = @"导航数据";
    }else if(record.type == DataType_Normal){
        label.text = @"免费数据";
    }else if(record.type == DataType_Base){
        label.text = @"基础数据包";
    }else if(record.type == DataType_Camera){
        label.text= @"增强电子眼";
    }
    
    UILabel* label1 = (UILabel*)[cell viewWithTag:2];
    label1.text = [NSString stringWithFormat:@"%.2fMB",record.fileSize/1024.0/1024.0];
    
    UIProgressView* progressView  = (UIProgressView*)[cell viewWithTag:4];
    progressView.progress = record.progress/100.0;
    [cell viewWithTag:7].hidden = YES;
    UIButton* btn = (UIButton*)[cell viewWithTag:3];
    if (record.download == DownloadState_None) {
        btn.hidden = NO;
    }else{
        if (record.download == DownloadState_Complete) {
            if (record.isUpdate){
                [btn setTitle:@"更新" forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"已完成" forState:UIControlStateNormal];
            }
            btn.hidden = NO;
            [cell viewWithTag:4].hidden = YES;
            [cell viewWithTag:5].hidden = NO;
            [cell viewWithTag:6].hidden = YES;
            
        }else{
            btn.hidden = YES;
            [cell viewWithTag:4].hidden = NO;
            [cell viewWithTag:5].hidden = NO;
            [cell viewWithTag:6].hidden = NO;
            if (record.download != DownloadState_Pause){
                [[MBOfflineDataManager sharedOfflineDataManager] start:record];
                [cell viewWithTag:7].hidden = NO;
                UILabel* label2 = (UILabel*)[cell viewWithTag:7];
                label2.text = [NSString stringWithFormat:@"%lld%%",record.progress];
            }else{
                UIButton* btn = (UIButton*)[cell viewWithTag:6];
                UIImage* imageNormal = [UIImage imageNamed:@"列表-开始-n.png"];
                UIImage* imageHighlighted = [UIImage imageNamed:@"列表-开始-p.png"];
                [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
                [btn setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
            }
        }
    }
    return cell;
}

#pragma mark - MBOfflineDataDelegate
/**
 *  下载离线数据状态跟踪
 */
- (void)onGetOfflineDataState:(MBOfflineRecord*)record{
    
    UITableView* tableViewCell = [_dictionary objectForKey:record.dataId];
    
    if(tableViewCell != nil){
        
        UIProgressView* progressView = (UIProgressView*)[tableViewCell viewWithTag:4];
        UILabel* label2 = (UILabel*)[tableViewCell viewWithTag:7];
        
        if (record.download == DownloadState_Downloading) { // 当前正在下载
            progressView.progress = record.progress / 100.0;
            label2.text = [NSString stringWithFormat:@"%lld%%",record.progress];
            
            NSLog(@"当前进度:%f----文件总大小:%lld",progressView.progress,record.fileSize);
        }else if(record.download == DownloadState_Start){   // 下载完成
            progressView.progress = record.progress / 100.0;
        }else if(record.download == DownloadState_Complete){    // 下载完成
            if([[MBAuth sharedAuth] checkLicense] != MBAuthError_none){
                [[MBAuth sharedAuth] updateLicense];
            }
            
            progressView.progress = 1.0;
            UIButton* btn = (UIButton*)[tableViewCell viewWithTag:3];
            [btn setTitle:@"已完成" forState:UIControlStateNormal];
            btn.hidden = NO;
            
            [tableViewCell viewWithTag:4].hidden = YES;
            [tableViewCell viewWithTag:5].hidden = NO;
            [tableViewCell viewWithTag:6].hidden = YES;
            [tableViewCell viewWithTag:7].hidden = YES;
        }else if(record.download == DownloadState_Error){   //  下载错误
            Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
            if ([r currentReachabilityStatus] == NotReachable) {    // 网络不可用
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"下载失败" message:@"网络未连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                UIButton* btn = (UIButton*)[tableViewCell viewWithTag:6];
                
                if (record.download != DownloadState_Pause){
                    UIImage* imageNormal = [UIImage imageNamed:@"列表-开始-n.png"];
                    UIImage* imageHighlighted = [UIImage imageNamed:@"列表-开始-p.png"];
                    [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
                    [btn setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
                    [[MBOfflineDataManager sharedOfflineDataManager] pause:record];
                    [tableViewCell viewWithTag:7].hidden = YES;
                }
            }
            else{  // 网络可用
                // 开始下载离线数据
                [[MBOfflineDataManager sharedOfflineDataManager] start:record];
            }
        }
    }
}

- (IBAction)downFile:(id)sender {
    UIButton* btn = (UIButton*)sender;
    UIView *cell = btn.superview;
    
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = cell.superview;
    }
    UIView *tableView = btn.superview;
    while (![tableView isKindOfClass:[UITableView class]]) {
        tableView = tableView.superview;
    }
    
    NSIndexPath *indexPath = [(UITableView *)tableView indexPathForCell:(UITableViewCell *)cell];
    MBOfflineRecord* record = [self.dataArray objectAtIndex:indexPath.row];
    
    if (record.download != DownloadState_Complete) {    // 数据未下载完
        [[MBOfflineDataManager sharedOfflineDataManager] start:record];
        [cell viewWithTag:7].hidden = NO;
        btn.hidden = YES;
        [cell viewWithTag:4].hidden = NO;
        [cell viewWithTag:5].hidden = NO;
        [cell viewWithTag:6].hidden = NO;
    }else{
        if (record.isUpdate){
            [[MBOfflineDataManager sharedOfflineDataManager] start:record];
            [cell viewWithTag:7].hidden = NO;
            btn.hidden = YES;
            [cell viewWithTag:4].hidden = NO;
            [cell viewWithTag:5].hidden = NO;
            [cell viewWithTag:6].hidden = NO;
        }
    }
}

- (IBAction)pause:(id)sender {
    UIButton* btn = (UIButton*)sender;
    UITableViewCell* cell = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        cell = (UITableViewCell*)[[[btn superview] superview] superview];
    }else{
        cell = (UITableViewCell*)[[btn superview] superview];
    }
    
    UITableView * tableView = (UITableView*)self.view;
    NSInteger row = [tableView indexPathForCell:cell].row;
    
    MBOfflineRecord* record = [self.dataArray objectAtIndex:row];
    
    if (record.download != DownloadState_Pause){    // 当前不在暂停状态
        UIImage* imageNormal = [UIImage imageNamed:@"列表-开始-n.png"];
        UIImage* imageHighlighted = [UIImage imageNamed:@"列表-开始-p.png"];
        [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [btn setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
        [[MBOfflineDataManager sharedOfflineDataManager] pause:record];
        [cell viewWithTag:7].hidden = YES;
    }else{  // 当前在暂停状态
        UIImage* imageNormal = [UIImage imageNamed:@"列表-暂停-n.png"];
        UIImage* imageHighlighted = [UIImage imageNamed:@"列表-暂停-p.png"];
        [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [btn setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
        [[MBOfflineDataManager sharedOfflineDataManager] start:record];
        [cell viewWithTag:7].hidden = NO;
    }
}

- (IBAction)stop:(id)sender {
    UIButton* btn = (UIButton*)sender;
    UIView *cell = btn.superview;
    
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = cell.superview;
    }
    UIView *tableView = btn.superview;
    while (![tableView isKindOfClass:[UITableView class]]) {
        tableView = tableView.superview;
    }
    
    NSIndexPath *indexPath = [(UITableView *)tableView indexPathForCell:(UITableViewCell *)cell];
    MBOfflineRecord* record = [self.dataArray objectAtIndex:indexPath.row];
    [[MBOfflineDataManager sharedOfflineDataManager] remove:record];
    
    [cell viewWithTag:3].hidden = NO;
    [cell viewWithTag:4].hidden = YES;
    [cell viewWithTag:5].hidden = YES;
    [cell viewWithTag:6].hidden = YES;
    [cell viewWithTag:7].hidden = YES;
    
    UIButton* btnStart = (UIButton*)[cell viewWithTag:3];
    [btnStart setTitle:@"马上下载" forState:UIControlStateNormal];
}
@end
