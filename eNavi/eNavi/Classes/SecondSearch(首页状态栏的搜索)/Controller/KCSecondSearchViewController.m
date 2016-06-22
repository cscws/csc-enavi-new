//
//  KCSecondSearchViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSecondSearchViewController.h"
#import "JZSearchBar.h"
#import "KCCityListViewController.h"
#import <iNaviCore/MBWorldManager.h>
#import <iNaviCore/MBPoiQuery.h>
#import "KCAroundMasController.h"
#import "DetailFrameModel.h"
#import "DetailModel.h"
#import "KCSearchResultController.h"
#import "KCSecondTableViewCell.h"
#import "historyModel.h"
/**
 Wmr信息
 */

@interface KCSecondSearchViewController ()<MBPoiQueryDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic, strong) KCCityListViewController *cityList;
@property (nonatomic, strong) MBPoiQuery *poiQury;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, strong) NSMutableArray *hisArr;
@property (nonatomic, assign) MBPoint point;
@property (nonatomic, weak) JZSearchBar *search;
@property (nonatomic, copy) NSString *searchStr;
@end

@implementation KCSecondSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setTableView];
    [self setNavigationBar];
    
    _poiQury = [MBPoiQuery sharedInstance];
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_offline;
    params.desiredMemorySize = 1024 * 1024 *1024;
    params.maxResultNumber = 100;
    params.searchRange = 5000;
    _poiQury.params = params;
    
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
    backBtn.frame = CGRectMake(0, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    
    CGFloat searchW = CGRectGetWidth(backBtn.frame);
    CGFloat searchX = CGRectGetMaxX(backBtn.frame);
    
    JZSearchBar *search = [[JZSearchBar alloc] initWithFrame:CGRectMake(searchX, 29, view.frame.size.width-2*searchW-30, 30)];
    self.search = search;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 0)];
#pragma 垃圾代码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(searchX+5, 31, 50, 26);
    leftBtn.backgroundColor = [UIColor colorWithRed:85.0/255 green:185.0/255 blue:234.0/255 alpha:1];
    [leftBtn.layer setMasksToBounds:YES];
    [leftBtn.layer setCornerRadius:2.0];
    [leftBtn addTarget:self action:@selector(jumpToCitylistVC) forControlEvents:UIControlEventTouchUpInside];
    self.cityBtn = leftBtn;
    [leftBtn setTitle:_cityName forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    search.leftView = leftView;
    search.leftViewMode = UITextFieldViewModeAlways;
   // search.returnKeyType = UIReturnKeySearch;
    search.textColor = kTextFontColor;
    [view addSubview:search];
    [view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat rightX = CGRectGetMaxX(search.frame);
    rightBtn.frame = CGRectMake(rightX, 29, 60, 30);
rightBtn.backgroundColor =[UIColor colorWithRed:92/255 green:170/255 blue:225/255 alpha:0.3];    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchRodeResultWithStr:isCellClicked:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:rightBtn];
}

- (void)setTableView
{
    _historyTableView.backgroundColor = kVCViewcolor;
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.tableFooterView = [UIView new];
}
 - (void)jumpToCitylistVC
{
    KCCityListViewController *city = [[KCCityListViewController alloc] init];
    city.VCClass = [self class];
    self.cityList = city;
    city.delegate = self;
    [self.navigationController pushViewController:city animated:YES];
}

- (void)bringCityNameToKCSencondSearchViewVCWithNode:(MBWmrNode *)node cityName:(NSString *)cityName
{
    self.cityNode = node;
    _cityName = cityName;
    NSLog(@"###%d",node.nodeId);
    [_cityBtn setTitle:_cityName forState:UIControlStateNormal];

}

- (IBAction)butonClick:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    self.poiQury.delegate = self;
    _searchStr = sender.currentTitle;
    [self.poiQury queryText:sender.currentTitle center:_centerPOI isNearby:YES];
}


- (IBAction)moreSearch:(UIButton *)sender
{
    KCAroundMasController *around = [[KCAroundMasController alloc] init];
    around.centerPoi = _centerPOI;
    [self.navigationController pushViewController:around animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCSecondTableViewCell *cell = [KCSecondTableViewCell cellWithtableView:tableView];
    cell.model = self.hisArr[indexPath.row];
    [cell buttonOnCellClicked:^(NSString *str){
        _search.text = str;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
    historyModel *model = self.hisArr[indexPath.row];
    [self searchRodeResultWithStr:model.name isCellClicked:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.hisArr removeObjectAtIndex:indexPath.row];
        
        [NSKeyedArchiver archiveRootObject:self.hisArr toFile:HistoryFilePath];
        [self.historyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
/**
 *  poi搜索失败
 */
- (void)poiQueryFailed
{
    [SVProgressHUD showInfoWithStatus:@"搜索失败"];
}

/**
 *  poi搜索没有结果
 */
- (void)poiQueryNoResult
{
    [SVProgressHUD showInfoWithStatus:@"没有结果"];
}
/**
 *  搜索分页结果回调
 *  @param  result  poi搜索结果 [MBPoiFavorite](#)
 */
- (void)poiQueryResultByPage:(NSArray *)result
{
    if (self.resultList.count!=0)[self.resultList removeAllObjects];
    NSInteger i = 0;
    for (MBPoiFavorite *favorPoi in result)
    {
        DetailModel *model = [[DetailModel alloc] init];
        DetailFrameModel *detailFrameModel = [[DetailFrameModel alloc] init];
        model.name = favorPoi.name;
        model.address = favorPoi.address;
        model.distance = favorPoi.distance;
        model.poi = favorPoi.pos;
        model.phoneNumber = favorPoi.phoneNumber;
        model.icon = @"poi";
        model.i = ++i;
        detailFrameModel.model = model;
        [self.resultList addObject:detailFrameModel];
        NSLog(@"######%ld",(long)model.i);
    }
    if (result.count>0)
    {
        [SVProgressHUD dismissAfterDuration:1.0];
        KCSearchResultController *searchR = [[KCSearchResultController alloc] init];
       // searchR.resultList = self.resultList;
        searchR.startPoint = self.centerPOI;
        searchR.titleStr = _searchStr;
        searchR.vcClass = [self class];
        [self.navigationController pushViewController:searchR animated:YES];
    }
}

- (void)searchRodeResultWithStr:(NSString *)str isCellClicked:(BOOL)isCellClicked
{

    [_search resignFirstResponder];
    self.poiQury.delegate = self;
    [self.poiQury setWmrId:self.cityNode.nodeId];
     NSLog(@"+++++%d",self.cityNode.nodeId);
    if(isCellClicked==YES)
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
#warning 这里出问题centerPoi
        _searchStr = str;
        [self.poiQury queryText:str center:_centerPOI isNearby:YES];
    }
#pragma 重复历史记录没写好
    else
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        _searchStr = self.search.text;
        if (self.search.text.length > 0) {
            [self.poiQury queryText:self.search.text center:_centerPOI isNearby:YES];
            
                historyModel *model = [historyModel modelWithName:self.search.text];
                [self historyArrAddModel:model];

        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请输入关键字"];
        }
    }
}
- (void)historyArrAddModel:(historyModel *)model
{
    [self.hisArr insertObject:model atIndex:0];
    [self.historyTableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.hisArr toFile:HistoryFilePath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_search endEditing:YES];
}

- (void)dealloc
{
    _poiQury.delegate = nil;
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
