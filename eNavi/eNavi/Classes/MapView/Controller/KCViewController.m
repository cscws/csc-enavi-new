//
//  KCViewController.m
//  navimap
//
//  Created by zhouxg on 15/7/17.
//  Copyright (c) 2015年 iDIVA. All rights reserved.
//

#import "KCViewController.h"
#import "KCNaviViewController.h"
#import <iNaviCore/MBGpsLocation.h>
#import <iNaviCore/MBCircleOverlay.h>
#import <iNaviCore/MBIconOverlay.h>
#import <iNaviCore/MBMapUtils.h>
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBWorldManager.h>
#import <iNaviCore/MBReverseGeocoder.h>
#import <UMMobClick/MobClick.h>
#import "UINavigationBar+Awesome.h"
#import "TabBarView.h"
#import "KCNaviDetailViewController.h"
#import "KCMoreViewController.h"
#import "KCRouteViewController.h"
#import "KCSearchViewController.h"
#import "KCCityListViewController.h"
#import "KCPoiDetailViewController.h"
#import "KCSecondSearchViewController.h"
#import "KCAroundMasController.h"
#import "popView.h"
#import "KCWebViewControler.h"
#import "KCWebViewControler.h"
#import <iNaviCore/MBOfflineDataManager.h>
#import "XMShareView.h"
@interface KCViewController ()<UIWebViewDelegate,MBGpsLocationDelegate,MBMapViewDelegate,UISearchBarDelegate,TabBarDelegate,MBReverseGeocodeDelegate,popViewDelegate>
@property (nonatomic, strong) XMShareView *shareView;
/**
 *  小车图标
 */
@property (nonatomic ,strong) MBIconOverlay *car;
/**
 *  大头针下的图层
 */
@property (nonatomic ,strong) MBCircleOverlay *circle;
/**
 *  GPS 定位
 */
@property (nonatomic ,strong) MBGpsLocation *gpsLocation;
/**
 *  起点
 */
@property (nonatomic ,assign) MBPoint startPoint;
/**
 *  终点
 */
@property (nonatomic ,assign) MBPoint endPoint;

/**
 *  地图
 */
@property (nonatomic ,strong) MBMapView *mapView;
/**
 *  终点大头针
 */
@property (nonatomic ,strong) MBAnnotation *annotationTitle;
/**
 *  终点大头针被选中
 */
@property (nonatomic ,strong) MBAnnotation *selectAnno;

/**
 *  存放大头针的数组
 */
@property (nonatomic ,strong) NSMutableArray *annoArrayM;
/**
 *  3D/卫星/分享/收藏
 */
@property (nonatomic ,weak) UIButton *moreBtn;
@property (nonatomic ,assign)BOOL selectMore;
/**
 *  路况
 */
@property (nonatomic ,weak) UIButton *rode;
@property (nonatomic ,assign)BOOL selectRode;
/**
 *  精选
 */
@property (nonatomic ,weak) UIButton *jxuan;
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
/**
 *去洗车
 */
@property (nonatomic ,weak) UIButton *washBtn;
/**
 tabBar
 */
@property (nonatomic ,weak) TabBarView *tab;
/**
 逆地理编码
 */
@property (nonatomic ,strong) MBReverseGeocoder *reverseGeocoder;
/**
 气泡弹出地址
 */
@property (nonatomic ,strong) NSString *address;
/**
 Wmr信息
 */
@property (nonatomic ,strong)MBWmrNode *cityNode;
/**
 城市nodeId
 */
@property (nonatomic ,assign)MBWmrObjId parentObjId;
/**
 *  poi 搜索类
 */
//@property (nonatomic ,strong) MBPoiQuery *poiQuery;
/**
 *  比例尺数据 label
 */
@property (nonatomic, strong) UILabel *ScaleLabel;
/**
 *  比例尺数据
 */
@property (nonatomic, assign) CGFloat MapScale;
/**
 *  leftView
 */
@property (nonatomic, strong) UIView *leftView;
/**
 *  BottomView
 */
@property (nonatomic, strong) UIView *bottomView;
/**
 *  rightView
 */
@property (nonatomic, strong) UIView *rightView;
/**
 *  rightView的transform
 */
@property (nonatomic, assign) CGAffineTransform lastTransform;

@property (nonatomic ,strong) MBWorldManager *worldManger;

@property (nonatomic ,weak) UIButton *cityBtn;
@property (nonatomic ,weak) UIView *bg;
@property (nonatomic ,weak) UIView *topView;
@property (nonatomic ,weak) UIImageView *imgV;
@property (nonatomic ,weak) UIButton *selectBtn;
@property (nonatomic ,weak) UIButton *compassBtn;

@property (nonatomic ,strong) KCSearchViewController *search;
@property (nonatomic ,strong) KCRouteViewController *route;
@property (nonatomic ,strong) KCMoreViewController *more;
@property (nonatomic ,strong) KCNaviViewController *navi;
@property (nonatomic ,strong) KCPoiDetailViewController *poiDetail;
@property (nonatomic ,strong) KCSecondSearchViewController *secondSear;
@property (nonatomic ,strong) KCAroundMasController *round;
//@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,copy) NSString *cityStr;

@end
@implementation KCViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [self getPrivateDocsDir];
    
    if(self.annoArrayM!=nil)
    {
        [self.mapView removeAnnotations:(NSArray *)self.annoArrayM];
        [self.annoArrayM removeAllObjects];
    }
    
    //    Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //    if ([r currentReachabilityStatus] == NotReachable) {
    //        // 网络不可用
    //        NSLog(@"viewWillAppear");
    //        CGRect mapRect = CGRectMake(0, 0, kMainScreenSizeWidth,kMainScreenSizeHeight);
    //        self.mapView = [[MBMapView alloc]initWithFrame:mapRect];
    //        [self.view insertSubview:_mapView atIndex:0];
    //        [self.mapView setZoomLevel:11.0 animated:YES];
    //        [self.mapView reloadMapData];
    //        self.mapView.mapDataMode = MBMapDataMode_offline;
    //    }
    //    else{
    //        NSLog(@"viewWillAppear");
    //        // 网络可用
    //        self.mapView.mapDataMode = MBMapDataMode_online;
    //      //  [self.mapView reloadMapData];
    //    }
    //self.mapView.mapDataMode = MBMapDataMode_online;
}

- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
    CGRect newStatusBarFrame = [(NSValue*)[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    BOOL bPersonalHotspotConnected = (CGRectGetHeight(newStatusBarFrame)==(40)?YES:NO);
    if(bPersonalHotspotConnected)
    {
        NSLog(@"有热点蓝条");
        _tab.frame = CGRectMake(15, kMainScreenSizeHeight-69, (kMainScreenSizeWidth-30), 39);
        
        self.leftView.frame = CGRectMake(kMainScreenSizeWidth - 70, kMainScreenSizeHeight-92, 1, 7);
        self.bottomView.frame = CGRectMake(CGRectGetMaxX(self.leftView.frame)-1, CGRectGetMaxY(self.leftView.frame), 50, 1);
        self.rightView.frame = CGRectMake(CGRectGetMaxX(self.bottomView.frame) - 1, CGRectGetMinY(self.leftView.frame), 1, CGRectGetHeight(self.leftView.frame));
        CGFloat popY = CGRectGetMidY(_moreBtn.frame)+28.5;
        _imgV.frame = CGRectMake(10, popY, kMainScreenSizeWidth-20, 150);
    }
    else
    {
        NSLog(@"无热点蓝条");
        _tab.frame = CGRectMake(15, kMainScreenSizeHeight-49, (kMainScreenSizeWidth-30), 39);
        self.leftView.frame = CGRectMake(kMainScreenSizeWidth - 70, kMainScreenSizeHeight-72, 1, 7);
        self.bottomView.frame = CGRectMake(CGRectGetMaxX(self.leftView.frame)-1, CGRectGetMaxY(self.leftView.frame), 50, 1);
        self.rightView.frame = CGRectMake(CGRectGetMaxX(self.bottomView.frame) - 1, CGRectGetMinY(self.leftView.frame), 1, CGRectGetHeight(self.leftView.frame));
        CGFloat popY = CGRectGetMidY(_moreBtn.frame)+8.5;
        _imgV.frame = CGRectMake(10, popY, kMainScreenSizeWidth-20, 150);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kVCViewcolor;
    if ([CLLocationManager locationServicesEnabled]) {
        self.gpsLocation = [[MBGpsLocation alloc]init];
        self.gpsLocation.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            self.gpsLocation.allowsBackgroundLocationUpdates = YES;
        }
        [self.gpsLocation startUpdatingLocation];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请打开GPS" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    CGRect mapRect = CGRectMake(0, 0, kMainScreenSizeWidth,kMainScreenSizeHeight);
    if (self.mapView == nil) {
        self.mapView = [[MBMapView alloc] initWithFrame:mapRect];
    }
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        [self.view insertSubview:_mapView atIndex:0];
        [self.mapView setZoomLevel:11.0 animated:YES];
        self.mapView.delegate = self;
        
        // 添加终点标注
        //        if ([self.mapView.delegate respondsToSelector:@selector(mbMapView:onAnnotationClicked:area:)]) {
        //            CGPoint pivot = {0.5,0.5};
        //            self.annotationTitle = [[MBAnnotation alloc]initWithZLevel:1 pos:self.endPoint iconId:40000 pivot:pivot];
        //            //[self.mapView.delegate mbMapView:self.mapView onAnnotationClicked:self.annotationTitle area:MBAnnotationArea_rightButton];
        //            [self.mapView addAnnotation:self.annotationTitle];
        //            [self.annoArrayM addObject:self.annotationTitle];
        //        }
        
        self.car = [[MBIconOverlay alloc]initWithFilePath:@"res/current_site.png" maintainPixelSize:YES];
        [self.mapView addOverlay:self.car];
    }
    
    //    Reachability *reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //    if ([reach currentReachabilityStatus] == NotReachable)
    //         {
    //
    //
    //        }
    //        else{
    //            CGRect mapRect = CGRectMake(0, 0, kMainScreenSizeWidth,kMainScreenSizeHeight);
    //            if (self.mapView == nil) {
    //
    //                self.mapView = [[MBMapView alloc]initWithFrame:mapRect];
    //                self.mapView.mapDataMode = MBMapDataMode_online;
    //            }
    //            if (self.mapView.authErrorType == MBSdkAuthError_none) {
    //                [self.view insertSubview:_mapView atIndex:0];
    //                [self.mapView setZoomLevel:11.0 animated:YES];
    //                self.mapView.delegate = self;
    //
    //
    //                // 添加终点标注
    //                //        if ([self.mapView.delegate respondsToSelector:@selector(mbMapView:onAnnotationClicked:area:)]) {
    //                //            CGPoint pivot = {0.5,0.5};
    //                //            self.annotationTitle = [[MBAnnotation alloc]initWithZLevel:1 pos:self.endPoint iconId:40000 pivot:pivot];
    //                //            //[self.mapView.delegate mbMapView:self.mapView onAnnotationClicked:self.annotationTitle area:MBAnnotationArea_rightButton];
    //                //            [self.mapView addAnnotation:self.annotationTitle];
    //                //            [self.annoArrayM addObject:self.annotationTitle];
    //                //        }
    //
    //                self.car = [[MBIconOverlay alloc]initWithFilePath:@"res/current_site.png" maintainPixelSize:YES];
    //                [self.mapView addOverlay:self.car];
    //            }
    //
    //        }
    
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(findMyself) userInfo:nil repeats:YES];
    [self setSearchView];
    [self addSubViewWithBtn];
    [self addTabView];
    
    // 初始化 poi 搜索类
    //    self.poiQuery = [MBPoiQuery sharedInstance];
    //    self.poiQuery.delegate = self;
    //    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    //    params.mode = MBPoiQueryMode_online;
    //    self.poiQuery.params = params;
    // 创建城市管理者
    _worldManger = [MBWorldManager sharedInstance];
    
    [self initAllViewcontroller];
    [self setupScaleLabel];
}

- (NSMutableArray *)annoArrayM
{
    if (_annoArrayM==nil)
    {
        _annoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _annoArrayM;
}

- (void)findMyself
{
    NSLog(@"findMyself");
    // [self.gpsLocation startUpdatingLocation];
}

- (void)addTabView
{
    
    TabBarView *tab = [[TabBarView alloc] initWithFrame:CGRectMake(15, kMainScreenSizeHeight-49, (kMainScreenSizeWidth-30), 39)];
    tab.backgroundColor = [UIColor whiteColor];
    [tab.layer setMasksToBounds:YES];
    [tab.layer setCornerRadius:2];
    tab.layer.borderWidth = 0.5;
    tab.layer.borderColor = kLayerBorderColor;
    tab.delegate = self;
    _tab = tab;
    [self.view addSubview:_tab];
}

- (void)initAllViewcontroller
{
    _round = [[KCAroundMasController alloc] init];
    
    _more = [[KCMoreViewController alloc] init];
}

-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        self.startPoint = self.car.postion = self.mapView.worldCenter = info.pos;
        NSLog(@"%d,%d",info.pos.x,info.pos.y);
        if (info.pos.x!=0 && info.pos.y!=0)
        {
            _cityNode = [_worldManger getNodeByPosition:_startPoint];
#pragma 公交搜索不能直接用_cityNode.nodeId
            _parentObjId = [_worldManger getParentId:_cityNode.nodeId];
            _cityStr = [_worldManger getCompleteRegionName:_startPoint level:3];
            [_cityBtn setTitle:_cityStr forState:UIControlStateNormal];
            NSLog(@"=======%@,%d",_cityStr,_parentObjId);
            // [self.poiQuery setWmrId:_cityNode.nodeId];
            [User setInteger:info.pos.x forKey:@"infoX"];
            [User setInteger:info.pos.y forKey:@"infoY"];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [self.gpsLocation stopUpdatingLocation];
}

- (void)addSubViewWithBtn
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
    compass.frame = CGRectMake(padding, 94, 30, 30);
    [compass setBackgroundImage:[UIImage imageNamed:@"compass"] forState:UIControlStateNormal];
    compass.layer.masksToBounds = YES;
    compass.layer.cornerRadius = 15;
    [compass addTarget:self action:@selector(hiddenCompass:) forControlEvents:UIControlEventTouchUpInside];
    compass.hidden = YES;
    self.compassBtn = compass;
    [self.view addSubview:compass];
    /**
     *  3D/卫星/分享/收藏
     */
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(btnX, 104, btnW, btnH);
    [self setButtonStyle:moreBtn imageName:@"btn_layout_normal" touchName:@"btn_layout_pressing" selectImage:@"btn_layout_pressing" action:@selector(shareWithCustomView)];
    self.moreBtn = moreBtn;
    
    /**
     *  路况
     */
    CGFloat rodeY = CGRectGetMaxY(moreBtn.frame);
    UIButton *rode = [UIButton buttonWithType:UIButtonTypeCustom];
    [rode setBackgroundImage:[UIImage imageNamed:@"btn_traffic_normal"] forState:UIControlStateNormal];
    
    rode.frame = CGRectMake(btnX, rodeY+10, btnW, btnH);
    [self setButtonStyle:rode imageName:@"btn_traffic_normal" touchName:@"btn_traffic_pressing" selectImage:@"btn_traffic_pressed" action:@selector(rodeDetail)];
    self.rode = rode;
    /**
     *  精选
     */
    CGFloat JXY = CGRectGetMaxY(rode.frame);
    UIButton *jxuan = [UIButton buttonWithType:UIButtonTypeCustom];
    jxuan.frame = CGRectMake(btnX, JXY+10, btnW, btnH);
    [self setButtonStyle:jxuan imageName:@"btn_chosen_normal" touchName:@"btn_chosen_pressing" selectImage:@"btn_chosen_pressed" action:@selector(jumpToJiXuanH5WebView)];
    self.jxuan = jxuan;
    /**
     *  放大
     */
    UIButton *zoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
    // _zoomOut.frame = CGRectMake(btnX, zoomOutY+80, btnW, btnH);
    zoomOut.frame = CGRectMake(btnX, kMainScreenSizeHeight-209, btnW, btnH);
    [self setButtonStyle:zoomOut imageName:@"btn_enlarge_normal" touchName:@"btn_enlarge_grey" selectImage:@"btn_enlarge_grey" action:@selector(ZoomOut:)];
    self.zoomOut = zoomOut;
    /**
     *  缩小
     */
    //CGFloat zoomInY = CGRectGetMaxY(_zoomOut.frame);
    UIButton *zoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //_zoomIn.frame = CGRectMake(btnX, zoomInY+10, btnW, btnH);
    zoomIn.frame = CGRectMake(btnX, kMainScreenSizeHeight-169, btnW, btnH);
    [self setButtonStyle:zoomIn imageName:@"btn_reduce_normal" touchName:@"btn_reduce_grey"selectImage:@"btn_reduce_grey" action:@selector(ZoomIn:)];
    self.zoomIn = zoomIn;
    /**
     *  回到当前位置
     */
    //CGFloat currentY = CGRectGetMaxY(_zoomIn.frame);
    UIButton *currentLoc = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLoc.frame = CGRectMake(padding, kMainScreenSizeHeight-119, btnW, btnH);
    currentLoc.selected = YES;
    [self setButtonStyle:currentLoc imageName:@"btn_locate_pressed" touchName:@"btn_locate_normal" selectImage:@"btn_locate_normal" action:@selector(goBack:)];
    self.currentLoc = currentLoc;
    
    UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    washBtn.frame = CGRectMake(padding, kMainScreenSizeHeight-169, btnW, btnH);
    [self setButtonStyle:washBtn imageName:@"btn_carwash_normal"  touchName:@"btn_carwash_pressing" selectImage:@"btn_carwash_normal" action:@selector(goWashCar:)];
    self.washBtn = washBtn;
}

- (void)shareWithCustomView
{
    //  [MobClick event:@"eNavi_opened" label:@"shouYe"];
    // _moreBtn.selected = !_moreBtn.selected;
    if(self.bg==nil || self.imgV==nil)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        self.bg = bgView;
        self.bg.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        
        //创建手势对象
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
        //点击的次数
        tap.numberOfTouchesRequired = 1;
        [self.bg addGestureRecognizer:tap];
        
        CGFloat popY = CGRectGetMidY(_moreBtn.frame)+8.5;
        UIImageView *imgV = [[UIImageView alloc] init];
        //imgV.backgroundColor = [UIColor redColor];
        imgV.image = [UIImage imageNamed:@"layout_p_frame"];
        imgV.userInteractionEnabled = YES;
        imgV.image = [[imgV image] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 5, 20) resizingMode:UIImageResizingModeStretch];
        imgV.frame = CGRectMake(10, popY, kMainScreenSizeWidth-20, 150);
        self.imgV = imgV;
        [self.bg addSubview:imgV];
        
        //透明 view 上在贴个 view
        
        popView *topView = [[popView alloc] init];
        topView.delegate  = self;
        topView.backgroundColor = kLineClor;
        topView.alpha = 1.0;
        // topView.userInteractionEnabled = YES;
        topView.frame = CGRectMake(9.5, 10, imgV.frame.size.width-19, imgV.frame.size.height-15);
        self.topView = topView;
        self.imgV.hidden = NO;
        [imgV addSubview:topView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:imgV];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:imgV];
    }
    else
    {
        self.bg.hidden = NO;
        self.imgV.hidden = NO;
    }
}

-(void)tapOnce:(UITapGestureRecognizer *)tapGes{
    self.bg.hidden = YES;
    self.imgV.hidden = YES;
}

- (void)sendButtonOnPopView:(UIButton *)button
{
    //    if (button != _selectBtn)
    //    {
    //        _selectBtn.selected = NO;
    //        _selectBtn = button ;
    //    }
    //    _selectBtn.selected = YES;
    
    button.selected = !button.selected;
    if ([[button currentTitle] isEqualToString:@"3D地图"])
    {
        if(button.selected)
        {
            [self.mapView setHeading:0];
            [self.mapView setElevation:0];
            self.mapView.enableBuilding = NO;
        }
        else
        {
            [self.mapView setElevation:90];
            self.mapView.enableBuilding = YES;
        }
    }
    else if ([[button currentTitle] isEqualToString:@"分享地图"])
    {
        if(!self.shareView){
            
            self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
            
            self.shareView.alpha = 0.0;
            
            self.shareView.shareTitle = NSLocalizedString(@"天翼导航", nil);
            
            self.shareView.shareText = NSLocalizedString(@"天翼导航，为您提供优质服务", nil);
            
            self.shareView.shareUrl = @"http://enavi.189.cn/enavi/";
            
            [self.view addSubview:self.shareView];
            
            [UIView animateWithDuration:1 animations:^{
                self.shareView.alpha = 1.0;
            }];
            
            
        }else{
            [UIView animateWithDuration:1 animations:^{
                self.shareView.alpha = 1.0;
            }];
            
        }
    }
    else if ([[button currentTitle] isEqualToString:@"收藏的点"])
    {
        
    }
    else if ([[button currentTitle] isEqualToString:@"卫星云图"])
    {
        
        if(button.selected)
        {
            [self.mapView setSatellitePicProvider:MBSatellitePicProvider_bing];
            [self.mapView setSatelliteMap:YES];
        }
        else
        {
            // [self.mapView setSatellitePicProvider:MBSatellitePicProvider_default];
            [self.mapView setSatelliteMap:NO];
        }
    }
    else if ([[button currentTitle] isEqualToString:@"清空地图"])
    {
        
        if (self.annoArrayM != nil) {
            [self.mapView removeAnnotation:[self.annoArrayM lastObject]];
            [self.annoArrayM removeLastObject];
        }
        
    }
    self.bg.hidden = YES;
    self.imgV.hidden = YES;
}



- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)rodeDetail
{
    _selectRode = !_selectRode;
    
    if (_selectRode)
    {
        _rode.selected = YES;
        self.mapView.enableTmc = YES;
    }
    else
    {
        _rode.selected = NO;
        self.mapView.enableTmc = NO;
    }
    
}

// 放大
- (void)ZoomOut:(id)sender {
    if(_zoomOut.selected==NO)
    {
        _zoomIn.selected = NO;
        //        _zoomOut.highlighted = YES;
        CGFloat zoomLevel = self.mapView.zoomLevel;
        [self.mapView setZoomLevel:zoomLevel + 1 animated:YES];
        NSLog(@"%f",zoomLevel);
        if(zoomLevel>=13)
        {
            _zoomOut.selected = YES;
            _zoomOut.adjustsImageWhenHighlighted = NO;
        }
    }
}
// 缩小
- (void)ZoomIn:(id)sender {
    if(_zoomIn.selected==NO)
    {
        _zoomOut.selected = NO;
        
        CGFloat zoomLevel = self.mapView.zoomLevel;
        [self.mapView setZoomLevel:zoomLevel - 1 animated:YES];
        if(zoomLevel<=1)
        {
            _zoomIn.selected = YES;
            _zoomIn.adjustsImageWhenHighlighted = NO;
        }
    }
    
}
//回到当前位置
- (void)goBack:(id)sender {
    if ((self.currentLoc.selected == NO))
    {
        [self.gpsLocation startUpdatingLocation];
        self.currentLoc.selected = YES;
        self.mapView.worldCenter = self.startPoint;
        _cityNode = [_worldManger getNodeByPosition:self.startPoint];
        _cityStr = [_worldManger getCompleteRegionName:_startPoint level:3];
        NSLog(@"=======%@,%d",_cityStr,_cityNode.nodeId);
        [_cityBtn setTitle:_cityStr forState:UIControlStateNormal];
        
    }
}

- (void)goWashCar:(UIButton *)btn
{
    KCWebViewControler *info = [[KCWebViewControler alloc] init];
    info.controllerType = @"车小秘";
    [self.navigationController pushViewController:info animated:YES];
}

- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName touchName:(NSString *)touchName selectImage:(NSString *)selectName action:(SEL)sel
{
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:touchName] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)setSearchView
{
    CGFloat padding = 10;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(padding, 25, kMainScreenSizeWidth-2*padding, 39)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView.layer setMasksToBounds:YES];
    [searchView.layer setCornerRadius:2];
    searchView.layer.borderWidth = 0.5;
    searchView.layer.borderColor = kLayerBorderColor;
    [self.view addSubview:searchView];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(5, 5, 60, 29);
    [cityBtn.layer setMasksToBounds:YES];
    [cityBtn.layer setCornerRadius:2.0];
    cityBtn.backgroundColor = [UIColor colorWithRed:85.0/255 green:185.0/255 blue:234.0/255 alpha:1];
    cityBtn.titleLabel.font = font(14.0);
    //[cityBtn setTitle:@"上海市" forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(jumpCityListVC) forControlEvents:UIControlEventTouchUpInside];
    self.cityBtn = cityBtn;
    [searchView addSubview:cityBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(65, 5, searchView.size.width-65, 29);
    //searchBtn.backgroundColor = [UIColor redColor];
    [searchBtn.titleLabel setFont:font(14.0)];
    [searchBtn.layer setMasksToBounds:YES];
    [searchBtn.layer setCornerRadius:2.0];
    [searchBtn setTitle:@"点击搜索" forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchBtn addTarget:self action:@selector(jumpToSerchViewVC) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
}

- (void)jumpToJiXuanH5WebView
{
    KCWebViewControler *JXuan =[[KCWebViewControler alloc] init];
    JXuan.controllerType = @"精选";
    [self.navigationController pushViewController:JXuan animated:YES];
}

- (void)jumpCityListVC
{
    KCCityListViewController *cityList = [[KCCityListViewController alloc] init];
    cityList.delegate = self;
    cityList.VCClass = [self class];
    [self.navigationController pushViewController:cityList animated:YES];
}

- (void)jumpToSerchViewVC
{
    KCSecondSearchViewController *secondSear = [self.storyboard instantiateViewControllerWithIdentifier:@"secondSear"];
    // self.secondSear = secondSear;
    secondSear.cityName = _cityBtn.currentTitle;
    secondSear.centerPOI = self.startPoint;
    secondSear.cityNode = self.cityNode;
    [self.navigationController pushViewController:secondSear animated:YES];
}

- (void)bringCityNameToKCViewVCWithNode:(MBWmrNode *)node cityName:(NSString *)cityName
{
    [_cityBtn setTitle:cityName forState:UIControlStateNormal];
    self.cityNode = node;
    _cityStr = cityName;
    self.mapView.worldCenter = node.pos;
}

- (void)tabBarView:(UIView *)view pushToOtherVCWithBtnTag:(int)btnTag
{
    if (btnTag==0)
    {
        KCNaviDetailViewController *naviDe = [[KCNaviDetailViewController alloc] init];
        naviDe.cityName = _cityNode.chsName;
        naviDe.startPoint = self.startPoint;
        naviDe.cityNode = _cityNode;
        [naviDe bringCityNode:^(MBWmrNode *node) {
            _cityNode = node;
            _cityStr = _cityNode.chsName;
            [_cityBtn setTitle:_cityStr forState:UIControlStateNormal];
            self.mapView.worldCenter = _cityNode.pos;
        }];
        [self.navigationController pushViewController:naviDe animated:YES];
    }
    else if (btnTag==1)
    {
        _round.centerPoi = _startPoint;
        _round.startPoi = _startPoint;
        [self.navigationController pushViewController:_round animated:YES];
        
        //      [self.navigationController pushViewController:_around animated:YES];
    }
    else if (btnTag==2)
    {
        KCRouteViewController *route = [[KCRouteViewController alloc] init];
        route.node = self.cityNode;
        route.startPoi = self.startPoint;
        route.parentObjId = self.parentObjId;
        // [self presentViewController:route animated:YES completion:nil];
        [self.navigationController pushViewController:route animated:YES];
    }
    else if (btnTag==3)
    {
        [self.navigationController pushViewController:_more animated:YES];
    }
}


-(void)mbMapView:(MBMapView *)mapView onPoiSelected:(NSString *)name pos:(MBPoint)pos
{
    if (self.selectAnno != nil)
    {
        [self.mapView removeAnnotation:self.selectAnno];
    }
    
    self.endPoint = pos;
    [self.mapView setWorldCenter:pos animated:YES];
    // 逆地理管理类
    self.reverseGeocoder = [[MBReverseGeocoder alloc]init];
    self.reverseGeocoder.delegate = self;
    self.reverseGeocoder.mode = MBReverseGeocodeMode_online;
    [self.reverseGeocoder reverseByPoint:&pos];
    
    CGPoint pivotPoint = {0.5,1};
    
    // 判断当前地图是否有大头针
    [self.mapView removeAnnotation:[self.annoArrayM lastObject]];
    if (self.annoArrayM != nil) {
        [self.annoArrayM removeLastObject];
    }
    
    // 创建新的大头针
    self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:pos iconId:10002 pivot: pivotPoint];
    // 设置大头针显示的样式
    MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
    calloutStyle.anchor.x = 0.5f;
    calloutStyle.anchor.y = 0;
    calloutStyle.leftIcon = 101;
    calloutStyle.rightIcon = 102;
    self.annotationTitle.calloutStyle = calloutStyle;
    self.annotationTitle.title = @"加载中..";
    self.annotationTitle.subTitle = @"加载中..";
    [self.mapView addAnnotation:self.annotationTitle];
    [self.annoArrayM addObject:self.annotationTitle];
    [self.annotationTitle showCallout:YES];
}
- (MBAnnotationArea)hitTest:(MBRect)clickArea
{
    return MBAnnotationArea_middleButton;
}
-(void)mbMapView:(MBMapView *)mapView onPoiDeselected:(NSString *)name pos:(MBPoint)pos
{
    NSLog(@"onPoiDeselected");
    
}
/**
 *  点击大头针的某区域
 */
-(void)mbMapView:(MBMapView *)mapView onAnnotationClicked:(MBAnnotation *)annot area:(MBAnnotationArea)area{
    if (area == 4) {
        [self startN:self.endPoint];
    }
    else if (area == 3)
    {
        KCPoiDetailViewController *detail = [storyB instantiateViewControllerWithIdentifier:@"poiDetail"];
        detail.name = _annotationTitle.title;
        detail.address = _annotationTitle.subTitle;
        detail.startPoi = _startPoint;
        detail.endPoi = _endPoint;
        //self.poiDetail = detail;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

- (void)mbMapView:(MBMapView *)mapView didPanStartPos:(MBPoint)pos
{
    self.currentLoc.selected = NO;
}

-(void)reverseGeocodeEventSucc:(MBReverseGeocodeObject*)rgObject
{
    
    self.mapView.worldCenter = rgObject.pos;
    self.annotationTitle.position = rgObject.navPos;
    self.annotationTitle.title = rgObject.poiName;
    self.annotationTitle.subTitle = rgObject.poiAddress;
}


-(void)reverseGeocodeEventFailed:(MBReverseGeocodeError)err
{
    
}

-(void)startN:(MBPoint)endPoint{
    
    endPoint.x = self.endPoint.x;
    endPoint.y = self.endPoint.y;
    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = self.startPoint;
    navi.endPoint = endPoint;
    // 选择导航模式的 index
    // self.navi = navi;
    navi.index = 0;
    
    NSLog(@"$$$$$%d,%d",endPoint.x,_startPoint.x)
    [self.navigationController pushViewController:navi animated:YES];
    //[self presentViewController:navi animated:YES completion:nil];
}

/**
 *  比例尺视图布局
 */
- (void)setupScaleLabel {
    // 比例尺数据 view
    self.ScaleLabel = [[UILabel alloc] init];
    self.ScaleLabel.frame = CGRectMake(kMainScreenSizeWidth - 70, kMainScreenSizeHeight-79, CGRectGetWidth(self.bottomView.frame), 15);
    self.ScaleLabel.font = [UIFont systemFontOfSize:9];
    self.ScaleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.ScaleLabel];
    
    // leftView
    self.leftView = [self makeScaleViewWithframe:CGRectMake(kMainScreenSizeWidth - 70, kMainScreenSizeHeight-72, 1, 7) color:[UIColor grayColor]];
    
    // bottomView
    self.bottomView = [self makeScaleViewWithframe:CGRectMake(CGRectGetMaxX(self.leftView.frame)-1, CGRectGetMaxY(self.leftView.frame), 50, 1) color:[UIColor grayColor]];
    
    // rightView
    self.rightView = [self makeScaleViewWithframe:CGRectMake(CGRectGetMaxX(self.bottomView.frame) - 1, CGRectGetMinY(self.leftView.frame), 1, CGRectGetHeight(self.leftView.frame)) color:[UIColor grayColor]];
    
}

// 地图视图发生变化的时候调用
-(void)mbMapView:(MBMapView *)mapView didChanged:(MBCameraSetting)cameraSetting{
    // 比例尺缩放私有方法
    [self scaleZooming];
}

- (void)scaleZooming {
    
    // 比例尺
    if (self.mapView.scale < 1000) {
        self.ScaleLabel.text = [NSString stringWithFormat:@"%.f米", self.mapView.scale];
    }else {
        self.ScaleLabel.text = [NSString stringWithFormat:@"%.f千米", self.mapView.scale / 1000];
    }
    
    // 比例尺动画
    [UIView animateWithDuration:0.3 animations:^{
        // 根据zoomLevel来判断比例尺的长度
        if (self.mapView.zoomLevel == 14) {
            
            [self changeWidthWithView:self.bottomView width:50];
            [self changeWidthWithView:self.ScaleLabel width:50];
            
            self.rightView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.lastTransform = CGAffineTransformIdentity;
            
        }else if (self.mapView.zoomLevel >= 11 && self.mapView.zoomLevel <= 13) {
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 10, 0);
            [self changeWidthWithView:self.bottomView width:60];
            [self changeWidthWithView:self.ScaleLabel width:60];
            self.lastTransform = CGAffineTransformIdentity;
            
        }else if (self.mapView.zoomLevel >= 8 && self.mapView.zoomLevel <= 10) {
            
            [self changeWidthWithView:self.bottomView width:65];
            [self changeWidthWithView:self.ScaleLabel width:65];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 15, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else if (self.mapView.zoomLevel >= 5 && self.mapView.zoomLevel <= 7) {
            
            [self changeWidthWithView:self.bottomView width:60];
            [self changeWidthWithView:self.ScaleLabel width:60];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 10, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else if (self.mapView.zoomLevel >= 2 && self.mapView.zoomLevel <= 4) {
            
            [self changeWidthWithView:self.bottomView width:65];
            [self changeWidthWithView:self.ScaleLabel width:65];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 15, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else {
            
            [self changeWidthWithView:self.bottomView width:60];
            [self changeWidthWithView:self.ScaleLabel width:60];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 10, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }
    }];
}

/**
 *  改变比例尺宽度
 *
 *  @param aView 改变哪个视图
 *  @param width 改变后的宽度
 */
- (void)changeWidthWithView:(UIView *)aView width:(CGFloat)width {
    CGRect rect = aView.frame;
    rect.size.width = width;
    aView.frame = rect;
}


/**
 *  创建比例尺视图方法
 *
 *  @param frame 比例尺的尺寸
 *  @param color 颜色
 *
 *  @return 创建好的视图
 */
- (UIView *)makeScaleViewWithframe:(CGRect)frame color:(UIColor *)color {
    UIView * View = [[UIView alloc] init];
    View.frame = frame;
    View.backgroundColor = color;
    [self.view addSubview:View];
    return View;
}
- (void)mbMapView:(MBMapView *)mapView onUserRasterDataUpdated:(MBMapDataMode)fromSource
{
    NSLog(@"地图更新");
}

/**
 *  使用手势旋转地图时触发
 *  @param  mapView 当前地图
 *  @return 空
 */
- (void)mbMapViewOnRotate:(MBMapView *)mapView
{
    _compassBtn.hidden = NO;
    CGFloat f = self.mapView.heading;
    _compassBtn.transform = CGAffineTransformMakeRotation(f*M_PI/180);
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

- (void)viewWillDisappear:(BOOL)animated
{
    // [_timer invalidate];
    NSLog(@"viewWillDisappear");
}

- (void)dealloc
{
    self.mapView.delegate = nil;
    //    self.lm = nil;
    self.reverseGeocoder = nil;
    self.reverseGeocoder.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    //    [self.mapView removeAnnotation:self.annotationTitle];
    //    [self.mapView removeAnnotation:self.selectAnno];
}

@end
