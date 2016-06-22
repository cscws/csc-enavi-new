//
//  MBDataManagerViewController.m
//  iOSSDKDemo
//
//  Created by zhouxg on 15/6/18.
//  Copyright (c) 2015年 zhouxg. All rights reserved.
//

#import "MBDataManagerViewController.h"
#import <iNaviCore/MBOfflineDataManager.h>
#import "MBDataDownloadViewController.h"

@interface MBDataManagerViewController ()<MBOfflineDataDelegate>
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
@end

@implementation MBDataManagerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 开启屏幕常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    return self;
}

- (void)dealloc{
    [MBOfflineDataManager sharedOfflineDataManager].delegate = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    [self.offlineDataDictionary removeAllObjects];
//    self.offlineDataArray = nil;
//    self.offlineCameraDataArray = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"下载中心";
    
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
                [self.tableView reloadData];
                
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
        NSLog(@"#######%lu",(unsigned long)self.offlineCameraDataArray.count);
        return self.offlineCameraDataArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
    if (indexPath.section == 0) {
        label1.text = [self.offlineDataArray objectAtIndex:indexPath.row];
    }else{
        MBOfflineRecord* record = [self.offlineCameraDataArray objectAtIndex:indexPath.row];
        label1.text = record.name;
    }
    
    return cell;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MBDataDownloadViewController* viewController = [segue destinationViewController];
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
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
    viewController.title = name;
    viewController.dataArray = array;
    NSLog(@"%lu",(unsigned long)array.count);
}

#pragma mark - PublicMethod
/**
 *  返回
 */
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
