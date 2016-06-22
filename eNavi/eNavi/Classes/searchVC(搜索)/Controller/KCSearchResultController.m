//
//  KCSearchResultController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/17.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSearchResultController.h"
#import "searchTableViewCell.h"
#import "KCRouteViewController.h"
#import "KCAroundMasController.h"
#import "KCPoiDetailViewController.h"
#import "DetailModel.h"
#import "DetailFrameModel.h"
#import "historyModel.h"
#import "KCNaviViewController.h"
#import "KCTapViewController.h"
#import "KCPoiOnMapViewController.h"
#import "DetailModel.h"
//#import <iNaviCore/MBPoiFavorite.h>

@interface KCSearchResultController ()<UITableViewDataSource,UITableViewDelegate,MBPoiQueryDelegate>
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) KCRouteViewController *route;
@property (nonatomic, strong) MBPoiQuery *poiQuery;
@end

@implementation KCSearchResultController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    [self creatTableView];
    _route = [[KCRouteViewController alloc] init];
    [self setupRefresh];
    // 创建 poi 搜索类
    self.poiQuery = [MBPoiQuery sharedInstance];
    self.poiQuery.delegate = self;
    
    // 设置 poi 搜索参数
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_online;
    self.poiQuery.params = params;
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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(searchX, 29, view.frame.size.width-2*searchW-5, 30);
    titleLabel.text = _titleStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(kMainScreenSizeWidth-40, 24, 40, 40);
    [mapBtn setImage:[UIImage imageNamed:@"btn_map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(jumpToMapView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:mapBtn];
}

- (void)creatTableView
{
   // NSInteger cout = _resultList.count;
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kMainScreenSizeWidth, kMainScreenSizeHeight-69) style:UITableViewStylePlain];
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _resultTableView.showsVerticalScrollIndicator = NO;
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.backgroundColor = kVCViewcolor;
    _resultTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self setupRefresh];
    }];

    [self.view addSubview:_resultTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"+++++%ld",(long)_resultList.count);
    return _resultList.count;
    
  //  return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *ID = [NSString stringWithFormat:@"searchResult%ld",(long)indexPath.row];
    NSString *ID = @"searchTableviewCell";
    searchTableViewCell *cell = [searchTableViewCell cellWithTableView:tableView andStr:ID];
    
     MBPoiFavorite *fav = self.resultList[indexPath.row];
     DetailFrameModel *fmodel = [[DetailFrameModel alloc] init];
     DetailModel *model = [[DetailModel alloc] init];
    model.name = fav.name;
    model.address = fav.address;
    model.icon = @"poi";
    model.phoneNumber = fav.phoneNumber;
    model.distance = fav.distance;
    model.poi = fav.pos;
    fmodel.model = model;
    cell.bgView.detailFrameModel = fmodel;
    cell.bgView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.bgView.imgView.image = [UIImage imageNamed:@"poi"];
    cell.contentView.backgroundColor = kVCViewcolor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.bgView buttonOncellClickedBlock:^(UIButton *btn, DetailFrameModel *frameModel) {
       if ([btn.currentTitle isEqualToString:@"导航"])
       {
           KCNaviViewController *navi = [[KCNaviViewController alloc] init];
           navi.startPoint = self.startPoint;
           navi.endPoint = model.poi;
           [self.navigationController pushViewController:navi animated:YES];
       }
        else
        {
            KCPoiDetailViewController *poiDe = [storyB instantiateViewControllerWithIdentifier:@"poiDetail"];
            poiDe.name = model.name;
            poiDe.address = model.address;
            poiDe.startPoi = self.startPoint;
            poiDe.endPoi = model.poi;
            poiDe.phoneNumber = model.phoneNumber;
            [self.navigationController pushViewController:poiDe animated:YES];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self jumpToMapView:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//        DetailFrameModel *frameModel = self.resultList[indexPath.row];
//        CGFloat cellH = frameModel.viewH + 5;
//        return cellH;
    return 90;
}


- (void)setupRefresh {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.poiQuery loadNextPage];
            [self.resultTableView reloadData];
            [self.resultTableView.footer endRefreshing];
        });

}

-(void)poiQueryResultByPage:(NSArray *)result{
    self.resultList = result;
    [self.resultTableView reloadData];
}


- (void)jumpToMapView:(UIButton *)btn
{
    KCPoiOnMapViewController *poiOnMap = [[KCPoiOnMapViewController alloc] init];
    poiOnMap.poiArray = _resultList;
    poiOnMap.titleStr = _titleStr;
    CATransition *animation2=[CATransition animation];
    animation2.type=@"Fade";
    [self.navigationController.view.layer addAnimation:animation2 forKey:nil];
    [self.navigationController pushViewController:poiOnMap animated:NO];

}

//-(void)poiQueryResultByPage:(NSArray *)result{
//    self.resultList = result;
//    [self.resultTableView reloadData];
//}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
