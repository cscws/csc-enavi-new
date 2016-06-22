//
//  KCNaviViewController.m
//  navimap
//
//  Created by zhouxg on 15/7/19.
//  Copyright (c) 2015年 iDIVA. All rights reserved.
//

#import "KCNaviViewController.h"

#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBNaviSession.h>
#import <iNaviCore/MBGpsTracker.h>
#import <iNaviCore/MBReverseGeocoder.h>
#import <iNaviCore/MBPoiQuery.h>
#import <iNaviCore/MBModelOverlay.h>
#import <iNaviCore/MBCqPoint.h>
#import <iNaviCore/MBRouteOverlay.h>
#import <iNaviCore/MBArrowOverlay.h>
#import <iNaviCore/MBCameraData.h>
#import <iNaviCore/MBPolylineOverlay.h>
#import <iNaviCore/MBGpsDebugger.h>

typedef NS_ENUM(NSUInteger, MapDirection){
    MapDirection_northUp,   // 上为北
    MapDirection_random     // 图随路转
};

@interface KCNaviViewController ()<MBMapViewDelegate,MBNaviSessionDelegate,MBGpsManagerDelegate,MBReverseGeocodeDelegate>

/**
 *  导航API
 */
@property (nonatomic ,strong) MBNaviSession *naviSession;
/**
 *  地图
 */
@property (nonatomic ,strong) MBMapView *mapView;
/**
 *  GPS 管理类
 */
@property (nonatomic ,strong) MBGpsTracker *gpsTracker;
/**
 *  逆地理类
 */
@property (nonatomic ,strong) MBReverseGeocoder *reverseGeocoder;
/**
 *  终点大头针
 */
@property (nonatomic ,strong) MBAnnotation *annotationTitle;
/**
 *  存放大头针的数组
 */
@property (nonatomic ,strong) NSMutableArray *annoArrayM;
/**
 *  存放路线的数组
 */
@property (nonatomic ,strong) NSMutableArray *routeArrayM;
/**
 *  小车图标
 */
@property(nonatomic,strong) MBModelOverlay* carModelOverlay;
/**
 *  路线规划
 */
@property(nonatomic,strong) MBRoutePlan* routePlan;
/**
 *  点信息
 */
@property (nonatomic ,assign) MBPoint point;
/**
 *  摄像机大头针
 */
@property (nonatomic ,strong) MBAnnotation *cameraAnnotation;
/**
 *  路线的基本信息
 */
@property (nonatomic ,strong) MBRouteBase *routeBase;
/**
 *  路线集合
 */
@property (nonatomic ,strong) MBRouteCollection *routeCollection;
/**
 *  逆地理对应类
 */
@property (nonatomic ,strong) MBReverseGeocodeObject *rgObject;
/**
 *  导航数据包
 */
@property (nonatomic ,strong) MBNaviSessionData *navisData;

/**
 *  地图朝向枚举值
 */
@property(nonatomic, assign) MapDirection mapDirection;
/**
 *  绘制线条
 */
@property (nonatomic ,strong) MBPolylineOverlay *polyLine;
/**
 *  gps 信息
 */
@property (nonatomic ,strong) MBGpsInfo *gpsInfo;
/**
 *  定时器
 */
@property (nonatomic ,strong) NSTimer *timer;
/**
 *  点击地图次数
 */
@property (nonatomic ,assign) NSInteger tapNum;

@property (nonatomic ,strong) MBRouteOverlay *oldrouteOverlay;

@property (nonatomic ,strong) MBRouteOverlay* routeOverlay;

//@property (nonatomic ,weak) UIButton *startNavi;
//@property (nonatomic, weak) UIButton *exitBtn;
@property (nonatomic, weak) UIButton *turnBtn;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *nextRodeNameLabel;
@property (nonatomic, weak) UIButton *distanceBtn;
@property (nonatomic, weak) UIButton *timeBtn;

@property (nonatomic, weak) UIButton *bottomExitBtn;
@property (nonatomic, weak) UILabel *bottomLabel;
@property (nonatomic, weak) UIButton *bottomSettingBtn;
@property (nonatomic, weak) UIImageView *imgV;
@property (nonatomic, assign) BOOL mapDrag;
@property (nonatomic, strong) NSDate *timeDate;

/**
 *  路况
 */
@property (nonatomic ,weak) UIButton *rode;

/**
 *  放大
 */
@property (nonatomic ,weak) UIButton *zoomOut;
/**
 *  缩小
 */
@property (nonatomic ,weak) UIButton *zoomIn;
/**
 *  回到当前位置
 */
@property (nonatomic ,weak) UIButton *currentLoc;

@property (nonatomic ,weak) UIButton *compassBtn;

@end

@implementation KCNaviViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapDrag = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(findMycar) userInfo:nil repeats:YES];
 //   [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.gpsTracker = [MBGpsTracker sharedGpsTracker];
    self.gpsTracker.delegate = self;
    self.naviSession.enableSound = YES;
//        Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
//        if ([r currentReachabilityStatus] == NotReachable) {
//            // 网络不可用
//            [self.naviSession setNaviMode:MBNaviMode_offline];
//            NSLog(@"2222");
//        }
//        else{
//            // 网络可用
//            [self.naviSession setNaviMode:MBNaviMode_online];
//            NSLog(@"111");
//        }
    
    [self drawRouteOverLayWithStart:self.startPoint withEnd:self.endPoint];
}

- (void)findMycar
{
    NSLog(@"findMycar");
    NSDate* date = [NSDate date];
    if ([date timeIntervalSinceDate:_timeDate] > 5.0) {
        _mapDrag = NO;
        [self.mapView setWorldCenter:self.navisData.carPos];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    
    // Do any additional setup after loading the view.
    // 屏幕常亮
    [[ UIApplication sharedApplication ] setIdleTimerDisabled:YES] ;
    [self getPrivateDocsDir];
    self.gpsInfo = nil;
    // 初始化摄像头
    self.cameraAnnotation = nil;
    self.navisData = [[MBNaviSessionData alloc]init];
    
    // 初始化起始点
    self.startPoi = [[MBPoiFavorite alloc]init];
    self.endPoi = [[MBPoiFavorite alloc]init];
    self.midPoi =[[MBPoiFavorite alloc]init];
    
    // 创建地图
    CGFloat H = self.view.frame.size.height;
    CGRect mapRect = CGRectMake(0, 0, self.view.frame.size.width, H);
    if (self.mapView == nil) {
        self.mapView = [[MBMapView alloc] initWithFrame:mapRect];
    }
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        [self.view insertSubview:_mapView atIndex:0];
        [self.mapView setZoomLevel:self.mapView.zoomLevel - 1 animated:YES];
    }else
    {
        NSLog(@"授权失败");
    }
    self.mapView.delegate = self;
    
    // 开启线路规划
    self.routePlan = [[MBRoutePlan alloc]init];
    // 添加终点标注
    //    if ([self.mapView.delegate respondsToSelector:@selector(mbMapView:onAnnotationClicked:area:)]) {
    //        CGPoint pivot = {0.5,0.5};
    //        self.annotationTitle = [[MBAnnotation alloc]initWithZLevel:1 pos:self.endPoint iconId:40000 pivot:pivot];
    //        [self.mapView.delegate mbMapView:self.mapView onAnnotationClicked:self.annotationTitle area:MBAnnotationArea_rightButton];
    //        [self.mapView addAnnotation:self.annotationTitle];
    //        [self.annoArrayM addObject:self.annotationTitle];
    //    }
    
    // 初始化路线集合
    self.routeCollection = [[MBRouteCollection alloc]init];
    
    // 设置导航
    self.naviSession = [MBNaviSession sharedInstance];
    MBNaviSessionParams* params = [MBNaviSessionParams defaultParams];
    params.autoTakeRoute = NO;
    self.naviSession.params = params;
    self.naviSession.delegate = self;
    
    // 设置导航 tmc 参数
    MBTmcOptions options;
    options.rerouteCheckInterval = 1000;
    options.routeColorUpdateInterval = 1000;
    options.enableTmcReroute = YES;
    [self.naviSession setTmcOptions:options];
    [self addsubview];
    [self addSubViewBtn];
    
}

- (NSMutableArray *)routeArrayM
{
    if(_routeArrayM==nil)
    {
        _routeArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _routeArrayM;
}

- (void)addsubview
{
    UIImageView *imgv = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"navi_title"];
    imgv.image = img;
    self.imgV = imgv;
    [self.view addSubview:imgv];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _turnBtn = btn;
    [self.imgV addSubview:self.turnBtn];
    
    UIView *view = [[UIView alloc] init];
    _headerView = view;
    [self.imgV addSubview:self.headerView];
    
    UILabel *label = [[UILabel alloc] init];
    _nextRodeNameLabel = label;
    _nextRodeNameLabel.textColor = [UIColor whiteColor];
    _nextRodeNameLabel.font = font(25.0);
    
    [self.headerView addSubview:self.nextRodeNameLabel];
    
    UIButton *disbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [disbtn setImage:[UIImage imageNamed:@"navi_location"] forState:UIControlStateNormal];
    disbtn.userInteractionEnabled = NO;
    disbtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _distanceBtn = disbtn;
    [self.headerView addSubview:self.distanceBtn];
    
    UIButton *tbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbtn setImage:[UIImage imageNamed:@"navi_time"] forState:UIControlStateNormal];
    tbtn.userInteractionEnabled = NO;
    tbtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _timeBtn = tbtn;
    [self.headerView addSubview:self.timeBtn];
    
    UIButton *bottomExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomExitBtn.backgroundColor = [UIColor whiteColor];
    [bottomExitBtn setImage:[UIImage imageNamed:@"navi_btn_close"] forState:UIControlStateNormal];
    [bottomExitBtn addTarget:self action:@selector(btn_exitNavi:) forControlEvents:UIControlEventTouchUpInside];
    _bottomExitBtn = bottomExitBtn;
    [self.view addSubview:self.bottomExitBtn];
    
    UILabel *bottomLabel= [[UILabel alloc] init];
    bottomLabel.backgroundColor = [UIColor whiteColor];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel = bottomLabel;
    [self.headerView addSubview:self.bottomLabel];
    
    UIButton *bottomSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomSettingBtn.backgroundColor = [UIColor whiteColor];
    [bottomSettingBtn setImage:[UIImage imageNamed:@"navi_btn_set"] forState:UIControlStateNormal];
    _bottomSettingBtn = bottomSettingBtn;
    [self.view addSubview:self.bottomSettingBtn];
    
    _nextRodeNameLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    [self layoutSubview];
    
}

- (void)addSubViewBtn
{
    CGFloat padding = 10;
    CGFloat btnW = 40;
    CGFloat btnH = 40;
    CGFloat btnX = kMainScreenSizeWidth-50;
    
    
    /**
     *  指南针
     */
    UIButton *compass = [UIButton buttonWithType:UIButtonTypeCustom];
    // compass.backgroundColor = [UIColor whiteColor];
    compass.frame = CGRectMake(padding, 150, 30, 30);
    [compass setBackgroundImage:[UIImage imageNamed:@"compass"] forState:UIControlStateNormal];
    compass.layer.masksToBounds = YES;
    compass.layer.cornerRadius = 15;
    [compass addTarget:self action:@selector(hiddenCompass:) forControlEvents:UIControlEventTouchUpInside];
    compass.hidden = YES;
    self.compassBtn = compass;
    [self.view addSubview:compass];
    
    
    /**
     *  沿途
     */
   // CGFloat rodeY = CGRectGetMaxY(moreBtn.frame);
    UIButton *rode = [UIButton buttonWithType:UIButtonTypeCustom];
    [rode setBackgroundImage:[UIImage imageNamed:@"btn_traffic_normal"] forState:UIControlStateNormal];
    
    rode.frame = CGRectMake(btnX, 150, btnW, btnH);
    [self setButtonStyle:rode imageName:@"btn_traffic_normal" touchName:@"btn_traffic_pressing" selectImage:@"btn_traffic_pressed" action:@selector(alongRode)];
    self.rode = rode;
    
    /**
     *  放大
     */
    UIButton *zoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
    // _zoomOut.frame = CGRectMake(btnX, zoomOutY+80, btnW, btnH);
    zoomOut.frame = CGRectMake(btnX, kMainScreenSizeHeight-169, btnW, btnH);
    [self setButtonStyle:zoomOut imageName:@"btn_enlarge_normal" touchName:@"btn_enlarge_pressing" selectImage:@"btn_enlarge_grey" action:@selector(ZoomIn:)];
    self.zoomOut = zoomOut;
    /**
     *  缩小
     */
    //CGFloat zoomInY = CGRectGetMaxY(_zoomOut.frame);
    UIButton *zoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //_zoomIn.frame = CGRectMake(btnX, zoomInY+10, btnW, btnH);
    zoomIn.frame = CGRectMake(btnX, kMainScreenSizeHeight-129, btnW, btnH);
    [self setButtonStyle:zoomIn imageName:@"btn_reduce_normal" touchName:@"btn_reduce_pressing"selectImage:@"btn_reduce_grey" action:@selector(ZoomOut:)];
    self.zoomIn = zoomIn;
    /**
     *  回到当前位置
     */
    //CGFloat currentY = CGRectGetMaxY(_zoomIn.frame);
    UIButton *currentLoc = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLoc.frame = CGRectMake(padding, kMainScreenSizeHeight-100, btnW, btnH);
    currentLoc.selected = YES;
    [self setButtonStyle:currentLoc imageName:@"btn_locate_pressed" touchName:@"btn_locate_normal" selectImage:@"btn_locate_normal" action:@selector(goBack:)];
    self.currentLoc = currentLoc;
    
}

- (void)alongRode
{
    MBPoiQuery *que = [MBPoiQuery sharedInstance];
    [que queryByRouteWithPoiType:1 carPoint:_navisData.carPos];
}

- (void)hiddenCompass:(UIButton *)sender
{
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.mapView setHeading:0.0 animated:YES];
        _compassBtn.transform = CGAffineTransformMakeRotation(0.0);
    } completion:^(BOOL finished) {
        _compassBtn.hidden = YES;
    }];
}

// 放大
- (void)ZoomOut:(id)sender {
    if(_zoomOut.selected==NO)
    {
        CGFloat zoomLevel = self.mapView.zoomLevel;
        [self.mapView setZoomLevel:zoomLevel - 1 animated:YES];
    }
}
// 缩小
- (void)ZoomIn:(id)sender {
    CGFloat zoomLevel = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:zoomLevel + 1 animated:YES];
}
//回到当前位置
- (void)goBack:(id)sender {
    if ((self.currentLoc.selected == NO))
    {
        self.currentLoc.selected = YES;
        self.mapView.worldCenter = self.navisData.carPos;
    }
    
}

- (void)mbMapViewOnRotate:(MBMapView *)mapView
{
    _compassBtn.hidden = NO;
    CGFloat f = self.mapView.heading;
    _compassBtn.transform = CGAffineTransformMakeRotation(f*M_PI/180);
}

- (void)mbMapView:(MBMapView *)mapView didPanStartPos:(MBPoint)pos
{
    self.currentLoc.selected = NO;
}


- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName touchName:(NSString *)touchName selectImage:(NSString *)selectName action:(SEL)sel
{
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:touchName] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)layoutSubview
{
    __weak __typeof(self) weakSelf=self;
    
    [weakSelf.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-2);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    
    [weakSelf.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.headerView.mas_left);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(weakSelf.headerView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(130);
    }];
    [weakSelf.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.mas_equalTo(weakSelf.turnBtn.mas_right);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(100);
    }];
    [weakSelf.nextRodeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headerView.mas_left);
        make.right.mas_equalTo(weakSelf.headerView.mas_right);
        make.top.mas_equalTo(weakSelf.headerView.mas_top).offset(20);
      //  make.bottom.mas_equalTo(weakSelf.headerView.mas_bottom);
        make.height.mas_equalTo(weakSelf.headerView.mas_height).multipliedBy(0.4);
    }];
    [weakSelf.distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headerView.mas_left);
       // make.right.mas_equalTo(weakSelf.headerView.mas_right);
        make.bottom.mas_equalTo(weakSelf.headerView.mas_bottom);
        make.top.mas_equalTo(weakSelf.nextRodeNameLabel.mas_bottom);
       // make.height.mas_equalTo(weakSelf.headerView.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(weakSelf.headerView.mas_width).multipliedBy(0.6);
    }];
    [weakSelf.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.distanceBtn.mas_right);
        make.right.mas_equalTo(weakSelf.headerView.mas_right);
        make.top.mas_equalTo(weakSelf.nextRodeNameLabel.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.headerView.mas_bottom);
    }];
    [weakSelf.bottomExitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.view);
        make.height.width.mas_equalTo(50);
       // make.width.mas_equalTo(50);
    }];
    [weakSelf.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bottomExitBtn.mas_right);
        make.right.mas_equalTo(weakSelf.bottomSettingBtn.mas_left);
        make.height.mas_equalTo(weakSelf.bottomExitBtn);
        make.bottom.mas_equalTo(weakSelf.view);
    }];
    [weakSelf.bottomSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bottomLabel.mas_right);
        make.right.bottom.mas_equalTo(weakSelf.view);
        make.height.width.mas_equalTo(weakSelf.bottomExitBtn.mas_width);
    }];
}



//- (UIView *)headerView
//{
//if (_headerView==nil)
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    _headerView = view;
//}
//    return _headerView;
//}

//- (UIButton *)turnBtn
//{
//    if (_turnBtn==nil)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor grayColor];
//        _turnBtn = btn;
//    }
//    return _turnBtn;
//}
//
//- (UIButton *)distanceBtn
//{
//    if (_distanceBtn==nil)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor greenColor];
//        _distanceBtn = btn;
//    }
//    return _distanceBtn;
//}
//- (UIButton *)timeBtn
//{
//    if (_timeBtn==nil)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor cyanColor];
//        _timeBtn = btn;
//    }
//    return _timeBtn;
//}
//
//- (UILabel *)curentRodeNameLabel
//{
//    if (_nextRodeNameLabel==nil)
//    {
//        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor yellowColor];
//        _nextRodeNameLabel = label;
//    }
//    return _nextRodeNameLabel;
//}

#pragma mark -PublicMethod
#pragma mark -

- (void)btn_exitNavi:(id)sender {
    [self.timer invalidate];
    [[ UIApplication sharedApplication ] setIdleTimerDisabled:NO] ;
    if([self.naviSession isInSimulation])
    {
    [self.naviSession endSimulation];
    }
    self.naviSession.enableSound = NO;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
#warning 这里是不是不走也可以导航??;
/**
 *  开始导航
 */
- (void)btn_startNavi{

    [self.annotationTitle showCallout:NO];
    self.mapDirection = MapDirection_random;
    if (self.routeBase == nil) {
        [SVProgressHUD showInfoWithStatus:@"路线规划失败 !" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (self.endPoi != nil) {
    }
    

    // 如果当前地图有路线
    if (self.routeBase!=nil) {
        [self.naviSession takeRoute:self.routeBase];
        
        self.carModelOverlay.heading = 0;
        
//        MBPoint s = [self.routeBase getFirstShapePoint];
//        MBPoint e = [self.routeBase getLastShapePoint];
//        NSLog(@"路线计算后终点位置:(%zd,%zd),(%zd,%zd)",s.x,s.y,e.x,e.y);
    }else{  // 当前地图没有路线,规划完路线,开始导航
        NSLog(@"没有路线");
//        if ([self.mapView.delegate respondsToSelector:@selector(mbMapView:onAnnotationClicked:area:)]) {
//            if (self.annotationTitle == nil) {  // 判断当前是否有终点
//                [SVProgressHUD showErrorWithStatus:@"导航失败,请选择终点!" maskType:SVProgressHUDMaskTypeBlack];
//                return;
//            }else{
//                CGPoint pivot = {0.5,0.5};
//                self.annotationTitle = [[MBAnnotation alloc]initWithZLevel:1 pos:self.rgObject.navPos iconId:40000 pivot:pivot];
//                [self.annotationTitle showCallout:NO];
//                [self.mapView.delegate mbMapView:self.mapView onAnnotationClicked:self.annotationTitle area:MBAnnotationArea_rightButton];
//                [self.naviSession takeRoute:self.routeBase];
//                
//                MBPoint s = [self.routeBase getFirstShapePoint];
//                MBPoint e = [self.routeBase getLastShapePoint];
//                NSLog(@"路线计算后终点位置:(%zd,%zd),(%zd,%zd)",s.x,s.y,e.x,e.y);
//            }
//        }
    }
    
    [self.mapView setWorldCenter:self.carModelOverlay.position];
    [self.mapView setZoomLevel:self.mapView.zoomLevel + MAXFLOAT];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _mapDrag = YES;
    _timeDate = [NSDate date];
}


/**
 *  通过起点,终点画线方法
 */
-(void)drawRouteOverLayWithStart:(MBPoint)start withEnd:(MBPoint)end{
    
    if (self.oldrouteOverlay != nil)
    {
      //  [self.mapView removeOverlay:self.oldrouteOverlay];
    }
    // start-end
    self.endPoi = [[MBPoiFavorite alloc]init];
    self.startPoi.pos = self.startPoint;
    self.endPoi.pos = end;
#pragma  途经点
    // 路线规划
    [self.routePlan setStartPoint:self.startPoi];
    [self.routePlan setEndPoint:self.endPoi];
    if(_midPoint.x!=0 && _midPoint.y!=0)
    {
        _midPoi.pos = _midPoint;
        [self.routePlan addWayPoint:_midPoi];
    }
    [self.routePlan setUseTmc:YES];
    
    [SVProgressHUD showWithStatus:@"路线规划中，请稍候..." maskType:SVProgressHUDMaskTypeBlack];
     self.naviSession.delegate = self;
  //  [self.naviSession setNaviMode:MBNaviMode_offline];
    [self.naviSession startRoute:self.routePlan routeMethod:MBNaviSessionRouteMethod_single];
    NSLog(@"++++++11111");
}
/**
 *  当前定位点和导航点画虚线
 *
 *  @param start 小车定位点
 *  @param end   导航定位点
 */
//- (void)drawLineWithstartPoint:(MBPoint)start endPoint:(MBPoint) end{
//    // 判断当前是否有虚线
//    NSLog(@"2222222222222222222222222222");
//    
//    if (self.polyLine != nil) {
//        [self.mapView removeOverlay:self.polyLine];
//    }
//    static MBPoint points[2];
//    points[0] = self.carModelOverlay.position;
//    points[1] = self.navisData.carPos;
//    self.polyLine = [[MBPolylineOverlay alloc]initWithPoints:points count:2 isClosed:NO];
//    [self.polyLine setWidth:50];
//    [self.polyLine setStrokeStyle:MBStrokeStyle_route];
//    [self.polyLine setOutlineUIColor:[UIColor redColor]];
//    [self.mapView addOverlay:self.polyLine];
//}



#pragma mark - MBGpsManagerDelegate

/**
 *  更新GPS信息
 */
-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    
    self.gpsInfo = info;
    
    // 如果这边不写地图判断的话,显示完授权失败程序会崩溃
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        if (self.carModelOverlay == nil) {
            self.carModelOverlay = [[MBModelOverlay alloc]initWithFilePath:@"res/red_car.obj" measuredInPixel:YES];
            self.carModelOverlay.scaleFactor = 0.3;
            [self.mapView addOverlay:self.carModelOverlay];
            [self.mapView setWorldCenter:self.carModelOverlay.position];
//            [SVProgressHUD showSuccessWithStatus:@"当前位置定位成功!" maskType:SVProgressHUDMaskTypeBlack];
            CGPoint point = {0.5,0.5};
            // 设置起点图标
            MBAnnotation *anno = [[MBAnnotation alloc]initWithZLevel:1 pos:info.pos iconId:40001 pivot:point];
            [self.mapView addAnnotation:anno];
            [self.mapView setWorldCenter:anno.position];
        }else{
            [self.carModelOverlay setNeedsDisplay];
        }
    }
}

#pragma mark - MBNaviSessionDelegate
#pragma mark -
/**
 *  路线计算，完成
 */
- (void)naviSessionResult:(MBRouteCollection*)routes{
    
    NSLog(@"++++++222222");
    
    if(self.routeArrayM.count>0)
    {
        [self.mapView removeOverlays:(NSArray *)self.routeArrayM];
        [self.routeArrayM removeAllObjects];
    }
    
    if (routes > 0){
        
        self.routeCollection = routes;
        MBRouteBase *route = routes.routeBases[0];
        self.routeBase = route;
//        MBPoint s = [self.routeBase getFirstShapePoint];
//        MBPoint e = [self.routeBase getLastShapePoint];
//        NSLog(@"路线计算后终点位置:(%zd,%zd),(%zd,%zd)",s.x,s.y,e.x,e.y);
        MBRouteOverlay* routeOverlay = nil;
        //for (MBRouteBase* routeBase in routes.routeBases){
            routeOverlay = [[MBRouteOverlay alloc] initWithRoute:[route getRouteBase]];
        
        // [routeOverlay setStrokeStyle:MBStrokeStyle_route];
       // routeOverlay.color=0xFF217600;
            // 当前定位点和导航点画虚线
//            MBPoint start = self.carModelOverlay.position;
//            MBPoint end = self.navisData.carPos;
//            [self drawLineWithstartPoint:start endPoint:end];
        [self.mapView addOverlay:routeOverlay];
        routeOverlay.clickEnable = YES;
        routeOverlay.width = 20.0;
        routeOverlay.outlineColor=0xFF217500;
        [routeOverlay setColor:0xFF217500];
         //   self.oldrouteOverlay = routeOverlay;
        CGPoint pivotPoint = {0.5,1};
        MBAnnotation *eAnno = [[MBAnnotation alloc] initWithZLevel:1 pos:_endPoint iconId:3002 pivot:pivotPoint];
        MBAnnotation *mAnno = [[MBAnnotation alloc] initWithZLevel:1 pos:_midPoint iconId:3004 pivot:pivotPoint];
        [self.mapView addAnnotation:eAnno];
        [self.mapView addAnnotation:mAnno];
        [self.routeArrayM addObject:routeOverlay];
        
        [SVProgressHUD showSuccessWithStatus:@"路线规划完毕!" maskType:SVProgressHUDMaskTypeBlack];
        [self.mapView setZoomLevel:self.mapView.zoomLevel + MAXFLOAT animated:YES];
       // }
        [self.mapView fitWorldArea:routeOverlay.boundingBox];
//开始导航
        if(_index == 100)
        {
            [self StartSimulation];
        }else
        {
        [self btn_startNavi];
        }
    }
    [SVProgressHUD dismiss];
   // [self.annotationTitle showCallout:NO];
}

- (void) naviSessionRouteFailed:(MBTRouterError)errCode moreDetails:(NSString*)details
{
    [SVProgressHUD showWithStatus:@"算路失败"];
    [SVProgressHUD dismissAfterDuration:1.0];
    
}

/**
 *   导航初始化后数据包回调
 */
- (void) naviSessionTracking:(MBNaviSessionData*)sData{
    self.navisData = sData;
    NSLog(@"++++++44444");
    // 设置底部标签
    
  //  NSLog(@"转向标上的距离:%ld,下个路口名称:%@,转向标转弯的进度:%ld,*****%d",(long)sData.turnIconDistance,sData.nextRoadName,(long)sData.turnIconProgress,sData.drifting);
    
//    [NSString stringWithFormat:@"%.1fkm",(long)_routeBase.getLength / 1000.0] timeStr:[NSString stringWithFormat:@"%ldh:%ldMin",(long)_routeBase.getEstimatedTime / 60 / 60,(long)_routeBase.getEstimatedTime % 60 % 60]
    _nextRodeNameLabel.text = sData.nextRoadName;
    _bottomLabel.text = [NSString stringWithFormat:@"当前:%@",sData.roadName];
    [_distanceBtn setTitle:[NSString stringWithFormat:@"%.1fkm",sData.routeLength/1000.0] forState:UIControlStateNormal];
    [_timeBtn setTitle:[NSString stringWithFormat:@"%ld:%ld:%ld",(long)(sData.remainingTime/3600),(long)(sData.remainingTime%3600/60),(long)(sData.remainingTime%60)] forState:UIControlStateNormal];
 
 //   NSLog(@"摄像头数量:%ld",(long)sData.cameraNum);
    self.carModelOverlay.position = self.navisData.carPos;
    
    if (self.mapDirection == MapDirection_northUp) {
        self.carModelOverlay.heading = sData.carOri - 90;
        [self.mapView setHeading:0];
    }else if (self.mapDirection == MapDirection_random){
        self.mapView.heading = 90 - sData.carOri;
        self.carModelOverlay.heading = 360 - self.mapView.heading;
    }
    
    if(!_mapDrag)
    {
        [self.mapView setWorldCenter:sData.carPos];
    }
    // 判断是否有下一个转弯
    if (sData.hasTurn) {
        
        NSString *image = [NSString stringWithFormat:@"turn_icons%ld.png",(long)sData.turnIcon];
        [self.turnBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
      //  [self.turnBtn setTitle:sData.turnDistanceStr forState:UIControlStateNormal];
    //    NSLog(@"%@,%ld",sData.turnDistanceStr,(long)sData.turnIconDistance);
    }
    
    CGPoint pivotPoint = {0.5,0.9};
    
    // 摄像头大头针是否显示
    if (sData.cameraNum > 0) {
        MBCameraData *d = [sData.cameras objectAtIndex:0];
        if (self.cameraAnnotation == nil) {
            self.cameraAnnotation = [[MBAnnotation alloc]initWithZLevel:1 pos:d.position iconId:1020 pivot:pivotPoint];
            [self.mapView addAnnotation:self.cameraAnnotation];
        }else{
            self.cameraAnnotation.position = d.position;
        }
    }else{
        [self.mapView removeAnnotation:self.cameraAnnotation];
        self.cameraAnnotation = nil;
    }
}
/**
 *  当前有新的转弯箭头需要显示。
 */
- (void) naviSessionNewArrow:(NSArray*)arrowShapes{
    MBArrowOverlay* arrow = [[MBArrowOverlay alloc] initWithPoints:arrowShapes];
    [self.mapView addOverlay:arrow];
}
/**
 *  当有转弯箭头需要删除时出发回调
 */
- (void) naviSessionDeleteArrow{
    for (MBOverlay* overlay in self.mapView.overlays) {
        if (![overlay isKindOfClass:[MBArrowOverlay class]]) {
            continue;
        }
        [self.mapView removeOverlay:overlay];
    }
}
/**
 *  偏航重计算完成
 */
-(void)naviSessionRerouteComplete:(MBRouteBase *)base{
    if(self.routeArrayM.count>0)
    {
        [self.mapView removeOverlays:(NSArray *)self.routeArrayM];
        [self.routeArrayM removeAllObjects];
    }
    
    self.routeBase = base;
    MBPoint s = [self.routeBase getFirstShapePoint];
    MBPoint e = [self.routeBase getLastShapePoint];
    NSLog(@"路线计算后终点位置:(%zd,%zd),(%zd,%zd)",s.x,s.y,e.x,e.y);
    
//    [self.mapView removeOverlays:self.routeArrayM];
//    [self.routeArrayM removeAllObjects];
    
    MBRouteOverlay* routeOverlay = [[MBRouteOverlay alloc] initWithRoute:[self.routeBase getRouteBase]];// base
    self.routeOverlay = routeOverlay;
    [self.routeOverlay enableTmcColors:YES];
    self.routeOverlay.clickEnable = YES;
    [self.mapView addOverlay:self.routeOverlay];
    [self.routeArrayM addObject:routeOverlay];
    [self.mapView setZoomLevel:self.mapView.zoomLevel + MAXFLOAT animated:YES];
    [self.naviSession takeRoute:self.routeBase];    // base
    
   // [self.annotationTitle showCallout:NO];
    [SVProgressHUD dismiss];
    if(!_mapDrag)
    {
     self.mapView.worldCenter = self.carModelOverlay.position;
    }
}

- (void)StartSimulation
{
    self.carModelOverlay.heading = 0;
    self.mapDirection = MapDirection_random;
    [self.mapView setZoomLevel:self.mapView.zoomLevel animated:YES];
// 开始模拟导航
[self.naviSession startSimulation];
}

-(void)dealloc{
    NSLog(@"********导航界面释放*****");
    //    // 取消常亮
    [self.naviSession removeRoute];
    self.navisData = nil;
    self.gpsTracker = nil;
    self.gpsTracker.delegate = nil;
    self.naviSession = nil;
    [MBGpsTracker cleanup];
    // [MBNaviSession cleanup];
    // self.routeBase = nil;
    // self.reverseGeocoder = nil;
    //  self.rgObject = nil;
    //  self.routePlan = nil;
    //  [self.mapView removeOverlay:self.carModelOverlay];
    //  [self.mapView removeAnnotation:self.cameraAnnotation];
    self.mapView.delegate = nil;
    [MBNaviSpeaker forceStop];
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


#pragma cache 目录
/*
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
 NSString *path = [paths objectAtIndex:0];
 */
@end
