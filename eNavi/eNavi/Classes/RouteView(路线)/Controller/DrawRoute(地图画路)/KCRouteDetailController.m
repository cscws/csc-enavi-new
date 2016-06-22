//
//  KCRouteDetailController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/17.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCRouteDetailController.h"
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBPoiFavorite.h>
#import <iNaviCore/MBNaviSession.h>
#import <iNaviCore/MBRouteOverlay.h>
#import <iNaviCore/MBBusQuery.h>
#import "BottomView.h"
#import "bottomModel.h"
#import "BusLineTableViewCell.h"
#import "KCDriveDetailViewController.h"
#import "KCNaviViewController.h"

@interface KCRouteDetailController ()<MBNaviSessionDelegate,BottomViewDelegate,MBBusQueryDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MBMapView *mapView;
@property (nonatomic, strong) MBRoutePlan *routePlan;
@property (nonatomic, strong) MBPoiFavorite *startFPoi;
@property (nonatomic, strong) MBPoiFavorite *endFPoi;
@property (nonatomic, strong) MBPoiFavorite *midFPoi;
@property (nonatomic, strong) MBNaviSession *naviSession;
@property (nonatomic, strong) MBRouteOverlay *oldRouteOverlay;
@property (nonatomic, strong) KCNaviViewController *navi;
@property (nonatomic, strong) Class vcClass;
@property (nonatomic, strong) MBRouteBase *routeBase;
@property (nonatomic, strong) NSMutableArray *busTransferArray;
@property (nonatomic, strong) MBBusQuery *busQuery;

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIButton *JCBtn;
@property (nonatomic, weak) UIButton *GJBtn;
@property (nonatomic, weak) UIButton *BXBtn;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UITableView *busRouteList;
@property (nonatomic, weak) BottomView *bottomView;

@property (nonatomic, copy) NSString *routeTypeStr;
@property (nonatomic, copy) NSString *distanceStr;
@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, assign) BOOL isAvoidCrowd;
@property (nonatomic, assign) BOOL isbuxing;
@property (nonatomic, assign) int i;
@end
@implementation KCRouteDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.naviSession.enableSound = NO;
    self.navigationController.navigationBar.hidden = YES;
    _i=1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self getPrivateDocsDir];
    self.startFPoi = [[MBPoiFavorite alloc]init];
    self.endFPoi = [[MBPoiFavorite alloc]init];
    self.midFPoi = [[MBPoiFavorite alloc] init];
    
    self.naviSession = [MBNaviSession sharedInstance];
    MBNaviSessionParams *params = [MBNaviSessionParams defaultParams];
    self.naviSession.params = params;
    params.autoTakeRoute = NO;
    
    CGRect mapRect = CGRectMake(0, 0, kMainScreenSizeWidth,kMainScreenSizeHeight);
    if (self.mapView == nil) {
        self.mapView = [[MBMapView alloc]initWithFrame:mapRect];
    }
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        [self.view insertSubview:_mapView atIndex:0];
        [self.mapView setZoomLevel:self.mapView.zoomLevel - 1 animated:YES];
    }
    [self setNavigationBar];
    [self addBottomView];
    if(self.naviSession.authErrorType == MBAuthError_none)
    {
        if (self.btnType==buttonType_JC)
        {
#warning 取出设置里值放在这里 (导航页面估计也要写)
            _JCBtn.selected = YES;
            [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:1 isBuXing:NO];
        }else if (self.btnType==buttonType_GJ)
        {
            _GJBtn.selected = YES;
            [self addBusViewSubviews];
        }
        else
        {
            _BXBtn.selected = YES;
            [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:1 isBuXing:YES];
            
        }
    }
    else
    {
        NSLog(@"================授权失败============");
    }
}

- (NSMutableArray *)busTransferArray
{
    if (_busTransferArray == nil)
    {
        _busTransferArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _busTransferArray;
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
    backBtn.frame = CGRectMake(12, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    NSArray *imgNameArray = @[@"btn_car_n",@"btn_bus_n",@"btn_walk_n"];
    NSArray *SimgNameArray = @[@"btn_car_p",@"btn_bus_p",@"btn_walk_p"];
    CGFloat maxX =(kMainScreenSizeWidth-130)/2;
    for (int i=0;i<3;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //  btn.backgroundColor = [UIColor redColor];
        [btn setBackgroundImage:[UIImage imageNamed:imgNameArray[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:SimgNameArray[i]] forState:UIControlStateSelected];
        btn.frame = CGRectMake(maxX+i*(30+20), 28, 30, 30);
        btn.tag = i+40;
        if (btn.tag==40)
        {
            self.JCBtn = btn;
        }
        else if (btn.tag==41)
        {
            self.GJBtn = btn;
        }
        else
        {
            self.BXBtn = btn;
        }
        [btn addTarget:self action:@selector(transportationToolsSelect:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
}

- (void)addBusViewSubviews
{
    _mapView.hidden = YES;
    if(self.bgView!=nil)
    {
        _bottomView.hidden = YES;
        _bgView.hidden = NO;
        _busRouteList.hidden = NO;
    }
    else
    {
        CGFloat pading = 5;
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(pading, 69, kMainScreenSizeWidth-2*pading, 50)];
        bgview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgview];
        self.bgView = bgview;
        
        CGFloat sourceH = CGRectGetHeight(bgview.frame);
        UIButton *sourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(pading, 0, (bgview.frame.size.width-10)/2, sourceH)];
        sourceBtn.userInteractionEnabled = YES;
        [bgview addSubview:sourceBtn];
        [sourceBtn setImage:[UIImage imageNamed:@"beginning"] forState:UIControlStateNormal];
        [sourceBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
        [sourceBtn setTitle:_starStr forState:UIControlStateNormal];
        sourceBtn.userInteractionEnabled = NO;
        sourceBtn.titleLabel.font = font(14.0);
        
        CGFloat desX = CGRectGetMaxX(sourceBtn.frame);
        UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(desX, 5, 1, 40)];
        centerLabel.backgroundColor = kLineClor;
        [bgview addSubview:centerLabel];
        
        UIButton *desBtn = [[UIButton alloc] initWithFrame:CGRectMake(desX+1, 0, (bgview.frame.size.width-10)/2, sourceH)];
        desBtn.userInteractionEnabled = YES;
        [bgview addSubview:desBtn];
        [desBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
        [desBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
        [desBtn setTitle:_endStr forState:UIControlStateNormal];
        desBtn.userInteractionEnabled = NO;
        desBtn.titleLabel.font = font(14.0);
        
        CGFloat tableY = CGRectGetMaxY(bgview.frame)+pading;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(pading, tableY, kMainScreenSizeWidth-2*pading, kMainScreenSizeHeight-tableY-pading)];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.layer.borderWidth = 0.5;
        tableView.layer.borderColor = kLayerBorderColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        _busRouteList = tableView;
        [self.view addSubview:_busRouteList];
        
        MBBusQuery *busQuery = [MBBusQuery sharedBusQuery];
        MBBusQueryParams* params = [[MBBusQueryParams alloc] init];
        params.desiredMemorySize = 1024 * 1024 *1024;
        params.maxResultNumber = 100;
        params.searchRange = 1000;
        busQuery.params = params;
        busQuery.mode = MBBusQueryMode_online;
#pragma 设置城市id
        busQuery.wmrId = _parentObjId;
        busQuery.delegate = self;
        MBBusRoutePlan *routePlan = [[MBBusRoutePlan alloc] init];
        routePlan.userOption = MBBusRouteRule_fastest;
        routePlan.startPoint = self.startPoi;
        routePlan.endPoint = self.endPoi;
        routePlan.shift = MBBusLineShift_day;
        [busQuery queryBusRoutes:routePlan];
        self.busQuery = busQuery;
    }
}

- (void)transportationToolsSelect:(UIButton *)btn
{
    _JCBtn.selected = NO;
    _BXBtn.selected = NO;
    _GJBtn.selected = NO;
    //切换交通工具
    if (btn!=_selectedBtn)
    {
        _selectedBtn.selected = NO;
        _selectedBtn = btn;
    }
    _selectedBtn.selected = YES;
    
    if (btn==_JCBtn)
    {
        [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:1 isBuXing:NO];
    }else if (btn==_GJBtn)
    {
        
        [self addBusViewSubviews];
    }
    else
    {
        [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:1 isBuXing:YES];
    }
}

- (void)getPrivateDocsDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"mapbar/cn/userdata"];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]){
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

- (void)drawOverlayWithStartPoi:(MBPoint)startPoi endPoi:(MBPoint)endPoi index:(int)i isBuXing:(BOOL)buxing
{
    
    
    _isbuxing = buxing;
    if (_bgView!=nil)
    {
        _bgView.hidden = YES;
        _busRouteList.hidden = YES;
        _mapView.hidden = NO;
        _bottomView.hidden = NO;
    }
    
    _routePlan = [[MBRoutePlan alloc] init];
    self.startFPoi.pos = startPoi;
    self.endFPoi.pos = endPoi;
    MBRouteRule routeRule;
    
    if (buxing)
    {
        _bgView.hidden = YES;
        _busRouteList.hidden = YES;
        _mapView.hidden = NO;
        _bottomView.hidden = YES;
        routeRule = MBRouteRule_walk;
    }
    else
    {
        switch (i) {
            case 1:
                routeRule = MBRouteRule_recommended;//推荐
                _routeTypeStr = @"系统推荐:";
                break;
            case 2:
                routeRule = MBRouteRule_shortest;
                _routeTypeStr = @"最短路线:";
                break;
            case 3:
                routeRule = MBRouteRule_fastest;
                _routeTypeStr = @"最快路线:";
                break;
            case 4:
                routeRule = MBRouteRule_economic;
                _routeTypeStr = @"经济路线:";
                break;
            default:
                break;
        }
    }
    //MBRouteRule routeRule = MBRouteRule_placeHolder;
    
    // tmc 参数
    MBTmcOptions options;
    // 算路的时间间隔,单位毫秒
    options.rerouteCheckInterval = 60000;
    // 路线颜色改变的时间间隔,单位毫秒
    options.routeColorUpdateInterval = 60000;
    options.enableTmcReroute = YES;
    [self.naviSession setTmcOptions:options];
    if (_isAvoidCrowd==YES) {
        options.enableTmcReroute = YES;
        [self.naviSession setTmcOptions:options];
        [_routePlan setUseTmc:YES];
    }
    else{
        options.enableTmcReroute = NO;
        [self.naviSession setTmcOptions:options];
        [_routePlan setUseTmc:NO];
    }
#pragma  终点，起点，途经点
    CGPoint pivotPoint = {0.5,1};
    [_routePlan setRule:routeRule];
    [_routePlan setStartPoint:self.startFPoi];
    [_routePlan setEndPoint:self.endFPoi];
    
    NSLog(@"++++++++++++++++%d",_midPoi.x);
    if(_midPoi.x !=0 && _midPoi.y !=0)
    {
        self.midFPoi.pos = _midPoi;
        BOOL add = [_routePlan addWayPoint:self.midFPoi];
        NSLog(@"++++++++++++++++%d",add);
        MBAnnotation *mAnno = [[MBAnnotation alloc] initWithZLevel:1 pos:_midPoi iconId:3004 pivot:pivotPoint];
        [self.mapView addAnnotation:mAnno];
    }
    // 创建新的大头针
    MBAnnotation *sAnno = [[MBAnnotation alloc] initWithZLevel:1 pos:_startPoi iconId:3003 pivot:pivotPoint];
    MBAnnotation *eAnno = [[MBAnnotation alloc] initWithZLevel:1 pos:_endPoi iconId:3002 pivot:pivotPoint];
    [self.mapView addAnnotation:sAnno];
    [self.mapView addAnnotation:eAnno];
    
    self.naviSession.delegate = self;
    [self.naviSession startRoute:_routePlan routeMethod:MBNaviSessionRouteMethod_single];
}

- (void) naviSessionResult:(MBRouteCollection*)routes
{
    bottomModel *model = [[bottomModel alloc] init];
    if (routes.num > 0)
    {
        MBRouteBase *routeBase = [routes.routeBases objectAtIndex:0];
        //        BOOL isSameRouteBase = [routeBase isEqualRouteBase:self.routeBase];
        if (self.routeBase!=nil)[self.mapView removeOverlay:_oldRouteOverlay];
        self.routeBase = routeBase;
        [self.naviSession takeRoute:routeBase];
        _oldRouteOverlay = [[MBRouteOverlay alloc] initWithRoute:[routeBase getRouteBase]];
        [self.mapView addOverlay:_oldRouteOverlay];
        _oldRouteOverlay.clickEnable = YES;
        _oldRouteOverlay.width = 20.0;
        _oldRouteOverlay.outlineColor=0xFF217500;
        [_oldRouteOverlay setColor:0xFF217500];
        MBRect rect = self.oldRouteOverlay.boundingBox;
        [self.mapView fitWorldArea:rect];
        //起点终点添加标注
    }
    if (!_isbuxing)
    {
        [self setBottomViewWithModel:model distanceStr:[NSString stringWithFormat:@"%.1fkm",(long)_routeBase.getLength / 1000.0] timeStr:[NSString stringWithFormat:@"%ldh:%ldMin",(long)_routeBase.getEstimatedTime / 60 / 60,(long)_routeBase.getEstimatedTime % 60 % 60] startStr:_starStr endStr:_endStr];
    }
    
}

- (void)changeRoutePlanWithTag:(int)btnTag
{
    
    //    BOOL isPlayIng = [MBNaviSpeaker isPlaying];
    //    if (isPlayIng)return;
    if (btnTag==53||btnTag==52)
    {
        if (btnTag==53)
        {
            ++_i;
            
            if (_i>4)
            {
                _i=4;
                return;
            }
        }
        else if (btnTag==52)
        {
            --_i;
            if(_i<1)
            {
                _i=1;
                return;
            }
        }
        
        switch (_i) {
            case 1:
                
                [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:1 isBuXing:NO];
                
                break;
            case 2:
                
                [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:2 isBuXing:NO];
                
                break;
            case 3:
                
                [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:3 isBuXing:NO];
                break;
            case 4:
                
                [self drawOverlayWithStartPoi:self.startPoi endPoi:self.endPoi index:4 isBuXing:NO];
                break;
                
            default:
                break;
        }
        
    }
    else if (btnTag==51)
    {
#pragma  这里也要途经点
        KCDriveDetailViewController *driveDetail = [storyB instantiateViewControllerWithIdentifier:@"driveDetail"];
        driveDetail.routeBase = _routeBase;
        driveDetail.timeStr = _timeStr;
        driveDetail.distanceStr = _distanceStr;
        driveDetail.startStr = _starStr;
        driveDetail.endStr = _endStr;
        driveDetail.startPoint = _startPoi;
        driveDetail.endPoint = _endPoi;
        driveDetail.midPoint = _midPoi;
        //        self.driveDetail = driveDetail;
        [self.navigationController pushViewController:driveDetail animated:YES];
    }
    else if (btnTag == 50)
    {
        KCNaviViewController *navi = [[KCNaviViewController alloc] init];
        navi.startPoint = _startPoi;
        navi.endPoint = _endPoi;
        navi.midPoint = _midPoi;
        navi.index = 0;
        //self.navi = navi;
        [self.navigationController pushViewController:navi animated:YES];
    }
    else if (btnTag == 54)
    {
        _isAvoidCrowd = !_isAvoidCrowd;
    }
}

- (void)setBottomViewWithModel:(bottomModel *)model distanceStr:(NSString *)distanceStr timeStr:(NSString *)timeStr startStr:(NSString *)starStr endStr:(NSString *)endStr
{
    model.distanceLabel = distanceStr;
    model.timeLabel = timeStr;
    model.startLabel = starStr;
    model.endLabel  = endStr;
    model.routeType = _routeTypeStr;
    
    _distanceStr = distanceStr;
    _timeStr = timeStr;
    
    self.bottomView.model = model;
}

- (void)naviSessionRouteFailed:(MBTRouterError)errCode moreDetails:(NSString *)details
{
    NSLog(@"Failed---%d",errCode);
}

- (void)addBottomView
{
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(5, kMainScreenSizeHeight-115, kMainScreenSizeWidth-10, 110)];
    bottomView.delegate = self;
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
}

/**
 * 发起搜索
 */
-(void)busQueryStart
{
    
}
/**
 * 网络请求失败，只有在网络失败是才回调该函数
 */
-(void)busQueryFailed
{
    [SVProgressHUD showSuccessWithStatus:@"网络请求失败" maskType:SVProgressHUDMaskTypeBlack];
}
/**
 * 搜索取消
 */
-(void)busQueryCanceled
{
    [SVProgressHUD showSuccessWithStatus:@"搜索取消" maskType:SVProgressHUDMaskTypeBlack];
}
/**
 * 搜索成功但没有结果
 */
-(void)busQueryNoresult
{
    [SVProgressHUD showSuccessWithStatus:@"没有结果" maskType:SVProgressHUDMaskTypeBlack];
}

/**
 * 搜索过程结束
 */
-(void)busQueryCompleted
{
    // MBBusQuery *busQuery = [MBBusQuery sharedBusQuery];
    NSInteger count = [_busQuery getResultNumber];
    // 防止再次点击查询时会出现重复的结果
    [self.busTransferArray removeAllObjects];
    if (count > 0) {
        for (int i = 0; i < count; i ++) {
            MBBusRoute *route = [_busQuery getResultAsBusRoute:i];
            [self.busTransferArray addObject:route];
            [self.busRouteList reloadData];
            [SVProgressHUD showSuccessWithStatus:@"公交查询成功..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"没有公交线路" maskType:SVProgressHUDMaskTypeBlack];
    }
}

/**
 * 获取当前城市失败，wmrId无效
 */
-(void)busQueryGetCurrentCityFailed
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.busTransferArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BusLineTableViewCell *cell = [BusLineTableViewCell cellWithTableview:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    MBBusRoute *route = self.busTransferArray[indexPath.row];
    NSString *string = route.desc;
    
    // 判断是否有换乘路线
    if ([string rangeOfString:@":"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@":" withString:@" 换乘 "];
        cell.textLabel.text = [NSString stringWithFormat:@"线路%zd : %@", indexPath.row + 1, string];
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"线路%zd : %@", indexPath.row + 1, string];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd分钟/%zd米",route.travelTime, route.distance];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)dealloc
{
    NSLog(@"********经济路线 最短路线释放*****");
    
    [self.naviSession removeRoute];
    self.naviSession = nil;
    self.naviSession.delegate = nil;
    //  [MBNaviSession cleanup];
    // self.routeBase = nil;
    // self.reverseGeocoder = nil;
    //  self.rgObject = nil;
    //  self.routePlan = nil;
    //  [self.mapView removeOverlay:self.carModelOverlay];
    //  [self.mapView removeAnnotation:self.cameraAnnotation];
    self.mapView.delegate = nil;
    //    [SVProgressHUD dismiss];
    //    self.routePlan = nil;
    //   // self.naviSession.delegate = nil;
    //    [self.naviSession removeRoute];
    //    //self.naviSession = nil;
    //    self.routeBase = nil;
    //    [self.mapView removeOverlay:self.oldRouteOverlay];
    //    self.bottomView.delegate = nil;
    //    self.bottomView = nil;
    //    //[self.busQuery cleanup];
    
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
