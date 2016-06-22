//
//  DetailSearchTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "MBDataManagerViewController.h"
#import <iNaviCore/MBOfflineDataManager.h>
#import "MBDataDownloadViewController.h"

@interface MBDataManagerViewController ()<MBOfflineDataDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  离线数据字典
 */
@property(nonatomic,retain)NSMutableDictionary* offlineDataDictionary;
/**
 *  离线数据数组
 */
@property(nonatomic,retain)NSArray* offlineDataArray;
/**
 *  离线电子眼数组
 */
@property(nonatomic,retain)NSArray* offlineCameraDataArray;
@property (nonatomic, weak) UITableView *dataTableView;
@end

@implementation MBDataManagerViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    [self createTableView];
    
    MBOfflineDataManager *offlineMgr = [MBOfflineDataManager sharedOfflineDataManager];
    offlineMgr.delegate = self;
    
    // 获得离线数据的记录信息
    [[MBOfflineDataManager sharedOfflineDataManager] getOfflineRecordList:^(CheckUpdateListState updateState) {
        
        if (updateState == CheckUpdateListState_Start) {
            NSLog(@"开始检测数据更新");
        }else if (updateState == CheckUpdateListState_Complete) {
            NSLog(@"数据更新检测完毕");
            // 获取离线数据信息
            NSArray* array = [MBOfflineDataManager sharedOfflineDataManager].offlineRecordList;
            
            if (array != nil) {
                NSMutableDictionary* dataDictionary = [[NSMutableDictionary alloc] init];
                NSMutableArray* dataArray = [[NSMutableArray alloc] init];
                NSMutableArray* cameraDataArray = [[NSMutableArray alloc] init];
                
                // 获取离线下载记录（下载的文件，大小进度等）
                for (MBOfflineRecord* record in array) {
                    if (record.type == DataType_Camera) {   // 电子眼数据
                        [cameraDataArray addObject:record];
                    }else{
                        NSMutableArray* mutableArray = [dataDictionary objectForKey:record.name];
                        if (mutableArray == nil){
                            
                            mutableArray = [[NSMutableArray alloc] init];
                            [mutableArray addObject:record];
                            
                            [dataDictionary setObject:mutableArray forKey:record.name];
                            [dataArray addObject:record.name];
                        }else{
                            [mutableArray addObject:record];
                        }
                    }
                }
                
                self.offlineDataDictionary = dataDictionary;
                self.offlineCameraDataArray = cameraDataArray;
                self.offlineDataArray = dataArray;
                [_dataTableView reloadData];
                // 判断当前是否有数据更新
                if ([MBOfflineDataManager sharedOfflineDataManager].isNew) {
                    UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"消息" message:@"有数据更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }
            }
        }else if (updateState == CheckUpdateListState_Error){
            NSLog(@"数据更新出现错误");
        }
    }];

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
    titleLabel.text = @"下载中心";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}

- (void)createTableView
{

UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 69, kMainScreenSizeWidth-10, kMainScreenSizeHeight-69)];
self.dataTableView = tableView;
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
/**
 *
 *  下载离线数据状态跟踪
 *  @param  record   离线下载记录信息
 *  @return 空
 */
-(void)onGetOfflineDataState:(MBOfflineRecord *)record{
    NSLog(@"dataId=%@ type=%u version=%@ fileSize=%lld name=%@ download=%u, process=%lld, downloadSize=%lld", record.dataId, record.type, record.version,record.fileSize,record.name, record.download, record.progress, record.downloadSize);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"地图数据";
    }else{
        return @"增强电子眼数据";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if(section == 0) {
        return self.offlineDataArray.count;
    }else{
       
        return self.offlineCameraDataArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MBDataDownloadViewController* viewController = [[MBDataDownloadViewController alloc] init];
        NSString* name = nil;
        NSArray* array = nil;
        if (indexPath.section==0) {
            name  = [self.offlineDataArray objectAtIndex:indexPath.row];
            array =[self.offlineDataDictionary objectForKey:name];
        }else{
            MBOfflineRecord* record  = [self.offlineCameraDataArray objectAtIndex:indexPath.row];
            name = record.name;
            array = [NSArray arrayWithObjects:record, nil];
        }
        viewController.titleName = name;
        viewController.dataArray = array;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // Configure the cell...
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.offlineDataArray objectAtIndex:indexPath.row];
    }else{
        MBOfflineRecord* record = [self.offlineCameraDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = record.name;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark - Navigation


#pragma mark - PublicMethod
/**
 *  返回
 */
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = nil;
    //[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //    [self.offlineDataDictionary removeAllObjects];
    //    self.offlineDataArray = nil;
    //    self.offlineCameraDataArray = nil;
}

@end
