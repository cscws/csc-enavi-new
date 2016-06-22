//
//  KCDetailResultController.m
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCDetailResultController.h"
#import "DetailSearchTableViewCell.h"
#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"
#import "KCSearchNaviDetailController.h"
#import "KCNaviViewController.h"
#import "NaviDetailHisModel.h"


@interface KCDetailResultController ()<UITableViewDelegate,UITableViewDataSource,MBPoiQueryDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *naviDetailHisArr;
@property (nonatomic, weak) UITableView *detailtableView;
@property (nonatomic, strong) MBPoiQuery *poiQuery;
@end

@implementation KCDetailResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self setNavigationBar];
    
    // 创建 poi 搜索类
    self.poiQuery = [MBPoiQuery sharedInstance];
    self.poiQuery.delegate = self;
    
    // 设置 poi 搜索参数
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_online;
    self.poiQuery.params = params;
    
}

- (NSMutableArray *)naviDetailHisArr
{
    
    if(_naviDetailHisArr == nil)
    {
       _naviDetailHisArr = [NSKeyedUnarchiver unarchiveObjectWithFile:NaviDetailHisFilePath];
    
    if(_naviDetailHisArr == nil)
    {
       _naviDetailHisArr = [NSMutableArray arrayWithCapacity:0];
    }
    }
    return _naviDetailHisArr;
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
    titleLabel.text = @"搜索结果";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenSizeWidth, kMainScreenSizeHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.detailtableView = tableView;
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self setupRefresh];
    }];
}

- (void)setupRefresh {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.poiQuery loadNextPage];
        [self.detailtableView reloadData];
        [self.detailtableView.footer endRefreshing];
    });
    
}

-(void)poiQueryResultByPage:(NSArray *)result{
    self.resultArr = result;
    [self.detailtableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailSearchTableViewCell *cell = [DetailSearchTableViewCell cellWithTableView:tableView];
    cell.contentView.backgroundColor = kVCViewcolor;
    DetailSearchFrameModel *fmodel = [[DetailSearchFrameModel alloc] init];
    DetailSearchModel *model = [[DetailSearchModel alloc] init];
    MBPoiFavorite *fav = self.resultArr[indexPath.row];
    model.name = fav.name;
    model.address = fav.address;
    model.distance = fav.distance;
    fmodel.model = model;
    cell.backView.frameModel = fmodel;
    cell.backView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.backView.imgView.image = [UIImage imageNamed:@"poi"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        MBPoiFavorite *fav = self.resultArr[indexPath.row];
        DetailSearchFrameModel *fmodel = [[DetailSearchFrameModel alloc] init];
        DetailSearchModel *model = [[DetailSearchModel alloc] init];
        model.name = fav.name;
        model.poi = fav.pos;
        model.address = fav.address;
        fmodel.model = model;
        NSString *name = fmodel.model.name;
        MBPoint poi = fmodel.model.poi;
        CGPoint point;
        point.x = poi.x;
        point.y = poi.y;
        NSValue *poiValue = [NSValue valueWithCGPoint:point];
        NSDictionary *dict = @{@"name":name,@"poi":poiValue};

        if (self.index==20)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bringStartValue" object:dict];
            [self jump];
        }
        else if (self.index==21)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bringEndValue" object:dict];
            [self jump];
        }
        else if (self.index==22)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bringMidValue" object:dict];
            [self jump];
        }
    //导航
       else if (self.index==13)
       {
           
             [[NSNotificationCenter defaultCenter] postNotificationName:kChangeHomeButtonTitle object:dict];
           [self jump];
       }
       else if (_index==14)
       {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kChangeCompanyButtonTitle object:dict];
           [self jump];
       }
    //路线
       else if (_index==15)
       {
           [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeTitle object:dict];
           [self jump];
       }
       else if (_index==16)
       {
           [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCompanyTitle object:dict];
           [self jump];
       }

       else
       {
         [self addNaviDetailHisWithModel:fmodel];
         KCNaviViewController *navi = [[KCNaviViewController alloc] init];
         navi.startPoint = self.startPoint;
           NSLog(@"*****%d",_startPoint.x);
         navi.endPoint = poi;
         [self.navigationController pushViewController:navi animated:YES];
        }
}

- (void)jump
{
[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailSearchFrameModel *fra = self.resultArr[indexPath.row];
//    CGFloat cellH = fra.viewH+2;
//    return cellH;
    return 55;
}

- (void)addNaviDetailHisWithModel:(DetailSearchFrameModel *)model
{
    CGPoint SPoint;
    SPoint.x = self.startPoint.x;
    SPoint.y = self.startPoint.y;
    NaviDetailHisModel *mod = [NaviDetailHisModel modelWithModel:model startPoint:SPoint];
    [self.naviDetailHisArr insertObject:mod atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.naviDetailHisArr toFile:NaviDetailHisFilePath];
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
