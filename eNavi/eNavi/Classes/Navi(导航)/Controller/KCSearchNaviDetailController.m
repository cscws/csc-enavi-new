//
//  KCSearchNaviDetailController.m
//  eNavi
//
//  Created by zuotoujing on 16/5/3.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSearchNaviDetailController.h"
#import "JZSearchBar.h"
#import "HistoryTableViewCell.h"
#import "historyModel.h"
#import "KCDetailResultController.h"
#import <iNaviCore/MBPoiQuery.h>
#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"
@interface KCSearchNaviDetailController ()<UITableViewDelegate,UITableViewDataSource,MBPoiQueryDelegate>
@property (nonatomic, weak) JZSearchBar *search;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hisArr;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, assign) MBPoint    point;
@property (nonatomic, strong) MBPoiQuery *poiQuery;
@property (nonatomic, copy) NSString *historyStr;
@end

@implementation KCSearchNaviDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
     self.navigationController.navigationBar.hidden = YES;
    [self createTableView];
    [self setNavigationBar];
    self.poiQuery = [MBPoiQuery sharedInstance];
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_online;
    params.searchRange = 5000;
    self.poiQuery.params = params;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_search becomeFirstResponder];
}

- (NSMutableArray *)resultList
{
    if (_resultList==nil)
    {
        _resultList = [NSMutableArray arrayWithCapacity:0];
    }
    return _resultList;
}


- (NSMutableArray *)hisArr
{
    if (_hisArr == nil) {
        _hisArr = [NSKeyedUnarchiver unarchiveObjectWithFile:HistoryFilePath];
        if (_hisArr == nil) {
            _hisArr = [NSMutableArray array];
        }
    }
    
    return _hisArr;
}

- (void)setNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, 64)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
    imgView.image = [UIImage imageNamed:@"top_bkg"];
    [view addSubview:imgView];
    [self.view addSubview:view];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    CGFloat searchW = CGRectGetWidth(backBtn.frame);
    CGFloat searchX = CGRectGetMaxX(backBtn.frame);
    
    JZSearchBar *search = [[JZSearchBar alloc] initWithFrame:CGRectMake(searchX, 29, view.frame.size.width-2*searchW-30, 30)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    search.leftView = leftView;
    search.leftViewMode = UITextFieldViewModeAlways;
    self.search = search;
    search.textColor = kTextFontColor;
    [view addSubview:search];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat rightX = CGRectGetMaxX(search.frame);
    rightBtn.frame = CGRectMake(rightX, 29, 60, 30);
rightBtn.backgroundColor =[UIColor colorWithRed:92/255 green:170/255 blue:225/255 alpha:0.3];    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchRodeResultWithStr:isCellClicked:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:rightBtn];
}

- (void)createTableView
{
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenSizeWidth, kMainScreenSizeHeight-69) style:UITableViewStyleGrouped];
    // _moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)searchRodeResultWithStr:(NSString *)str isCellClicked:(BOOL)isCellClicked
{
    
    self.poiQuery.delegate = self;
    self.point = self.cityNode.pos;
    [self.poiQuery setWmrId:self.cityNode.nodeId];
    if(isCellClicked==YES)
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        [self.poiQuery queryByKeyword:str center:self.point];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        if (self.search.text.length > 0) {
            [self.poiQuery queryByKeyword:self.search.text center:self.point];
            
            if (![self.search.text isEqualToString:_historyStr])
            {
                historyModel *model = [historyModel modelWithName:self.search.text];
                [self historyArrAddModel:model];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请输入关键字"];
        }
    }
    _historyStr = self.search.text;
}

#warning 每次数组会更新所以历史记录出错
- (void)historyArrAddModel:(historyModel *)model
{
    [self.hisArr insertObject:model atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.hisArr toFile:HistoryFilePath];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"history";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.hisArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    historyModel *model = [[historyModel alloc] init];
    model = self.hisArr[indexPath.row];
    [self searchRodeResultWithStr:model.name isCellClicked:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.hisArr removeObjectAtIndex:indexPath.row];
        
        [NSKeyedArchiver archiveRootObject:self.hisArr toFile:HistoryFilePath];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

/**
 *  poi搜索失败
 */
-(void)poiQueryFailed{
    
    [SVProgressHUD showInfoWithStatus:@"搜索失败"];
}
/**
 *  poi没有结果
 */
-(void)poiQueryNoResult{
    
    [SVProgressHUD showInfoWithStatus:@"没有结果"];
}

/**
 *  搜索分页结果回调
 *  @param  result    poi搜索结果 [MBPoiFavorite](#)
 */
- (void)poiQueryResultByPage:(NSArray *)result
{
    if (self.resultList!=nil)
    {
        [self.resultList removeAllObjects];
    }
    NSInteger i = 0;
    if (result != nil) {
        for (MBPoiFavorite *favPOi in result)
        {
            DetailSearchFrameModel *frameModel = [[DetailSearchFrameModel alloc] init];
            DetailSearchModel *model = [[DetailSearchModel alloc] init];
            model.name = favPOi.name;
            model.address = favPOi.address;
            model.phoneNumber = favPOi.phoneNumber;
            model.poi = favPOi.pos;
            model.icon = @"poi";
            model.i = ++i;
            frameModel.model = model;
            [self.resultList addObject:frameModel];
        }
    }
    [SVProgressHUD dismissAfterDuration:1.0];
    KCDetailResultController *detailR =[[KCDetailResultController alloc] init];
    detailR.resultArr = self.resultList;
    detailR.index = self.index;
    detailR.startPoint = self.startPoint;
    [self.navigationController pushViewController:detailR animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
