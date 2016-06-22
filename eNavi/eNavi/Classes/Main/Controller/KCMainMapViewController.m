//
//  KCMainMapViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/27.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCMainMapViewController.h"
#import "KCTapViewController.h"
#import "popView.h"
#import "DropView.h"

@interface KCMainMapViewController ()<DropViewDelegate,MBGpsLocationDelegate,MBMapViewDelegate,popViewDelegate>

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
 *  3D/卫星/分享/收藏
 */
@property (nonatomic ,weak) UIButton *moreBtn;

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
@property (nonatomic ,weak) UIButton *compassBtn;


@end

@implementation KCMainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    if ([CLLocationManager locationServicesEnabled]) {
        self.gpsLocation = [[MBGpsLocation alloc]init];
        self.gpsLocation.delegate = self;
        [self.gpsLocation startUpdatingLocation];
    }
    CGRect mapRect = CGRectMake(0, 0, kMainScreenSizeWidth,kMainScreenSizeHeight);
    if (self.mapView == nil) {
        self.mapView = [[MBMapView alloc]initWithFrame:mapRect];
    }
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        [self.view insertSubview:_mapView atIndex:0];
        [self.mapView setZoomLevel:10.0 animated:YES];
        self.mapView.delegate = self;
    }
    [self addSubViewWithBtn];
    [self setupScaleLabel];
}


- (void)setNavigationBarWithTitle:(NSString *)title
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
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
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
   
    
//    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreBtn.frame = CGRectMake(btnX, 94, btnW, btnH);
//    [self setButtonStyle:moreBtn imageName:@"btn_layout_normal" touchName:@"btn_layout_pressing" selectImage:@"btn_layout_pressing" action:@selector(shareWithCustomView:)];
//    self.moreBtn = moreBtn;
    
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

/**
 *  比例尺视图布局
 */
- (void)setupScaleLabel {
    // 比例尺数据 view
    self.ScaleLabel = [[UILabel alloc] init];
    self.ScaleLabel.frame = CGRectMake(kMainScreenSizeWidth - 80, CGRectGetMaxY(self.view.frame) - 43, CGRectGetWidth(self.bottomView.frame), 15);
    self.ScaleLabel.font = [UIFont systemFontOfSize:9];
    self.ScaleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.ScaleLabel];
    
    // leftView
    self.leftView = [self makeScaleViewWithframe:CGRectMake(kMainScreenSizeWidth - 80, CGRectGetMaxY(self.view.frame) - 35, 1, 7) color:[UIColor grayColor]];
    
    // bottomView
    self.bottomView = [self makeScaleViewWithframe:CGRectMake(CGRectGetMaxX(self.leftView.frame), CGRectGetMaxY(self.leftView.frame), 60, 1) color:[UIColor grayColor]];
    
    // rightView
    self.rightView = [self makeScaleViewWithframe:CGRectMake(CGRectGetMaxX(self.bottomView.frame) - 1, CGRectGetMinY(self.leftView.frame), 1, CGRectGetHeight(self.leftView.frame)) color:[UIColor grayColor]];
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

- (void)mbMapViewOnRotate:(MBMapView *)mapView
{
    _compassBtn.hidden = NO;
    CGFloat f = self.mapView.heading;
    _compassBtn.transform = CGAffineTransformMakeRotation(f*M_PI/180);
}

// 地图视图发生变化的时候调用
-(void)mbMapView:(MBMapView *)mapView didChanged:(MBCameraSetting)cameraSetting{
    // 比例尺缩放私有方法
    [self scaleZooming];
}

- (void)scaleZooming {
  //  NSLog(@"zoomLevel===%.f", self.mapView.zoomLevel);
    
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
            
            [self changeWidthWithView:self.bottomView width:60];
            [self changeWidthWithView:self.ScaleLabel width:60];
            
            self.rightView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.lastTransform = CGAffineTransformIdentity;
            
        }else if (self.mapView.zoomLevel >= 11 && self.mapView.zoomLevel <= 13) {
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 10, 0);
            [self changeWidthWithView:self.bottomView width:70];
            [self changeWidthWithView:self.ScaleLabel width:70];
            self.lastTransform = CGAffineTransformIdentity;
            
        }else if (self.mapView.zoomLevel >= 8 && self.mapView.zoomLevel <= 10) {
            
            [self changeWidthWithView:self.bottomView width:75];
            [self changeWidthWithView:self.ScaleLabel width:75];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 15, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else if (self.mapView.zoomLevel >= 5 && self.mapView.zoomLevel <= 7) {
            
            [self changeWidthWithView:self.bottomView width:70];
            [self changeWidthWithView:self.ScaleLabel width:70];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 10, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else if (self.mapView.zoomLevel >= 2 && self.mapView.zoomLevel <= 4) {
            
            [self changeWidthWithView:self.bottomView width:75];
            [self changeWidthWithView:self.ScaleLabel width:75];
            
            self.rightView.transform = CGAffineTransformTranslate(self.lastTransform, 15, 0);
            self.lastTransform = CGAffineTransformIdentity;
        }else {
            
            [self changeWidthWithView:self.bottomView width:70];
            [self changeWidthWithView:self.ScaleLabel width:70];
            
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


- (void)setButtonStyle:(UIButton *)btn imageName:(NSString *)imageName touchName:(NSString *)touchName selectImage:(NSString *)selectName action:(SEL)sel
{
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:touchName] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//- (void)shareWithCustomView:(UIButton *)btn
//{
//    
//  //  _moreBtn.selected = !_moreBtn.selected;
//    if(self.bg==nil || self.imgV==nil)
//    {
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight)];
//        bgView.backgroundColor = [UIColor blackColor];
//        bgView.alpha = 0.5;
//        self.bg = bgView;
//        self.bg.hidden = NO;
//        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
//        
//        //创建手势对象
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
//        //点击的次数
//        tap.numberOfTouchesRequired = 1;
//        [self.bg addGestureRecognizer:tap];
//        
//        CGFloat popY = CGRectGetMidY(_moreBtn.frame)+8.5;
//        UIImageView *imgV = [[UIImageView alloc] init];
//        //imgV.backgroundColor = [UIColor redColor];
//        imgV.image = [UIImage imageNamed:@"layout_p_frame"];
//        imgV.userInteractionEnabled = YES;
//        imgV.image = [[imgV image] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 5, 20) resizingMode:UIImageResizingModeStretch];
//        imgV.frame = CGRectMake(10, popY, kMainScreenSizeWidth-20, 150);
//        self.imgV = imgV;
//        [self.bg addSubview:imgV];
//        
//        //透明 view 上在贴个 view
//        
//        popView *topView = [[popView alloc] init];
//        topView.delegate  = self;
//        topView.backgroundColor = kLineClor;
//        topView.alpha = 1.0;
//        // topView.userInteractionEnabled = YES;
//        topView.frame = CGRectMake(9.5, 10, imgV.frame.size.width-19, imgV.frame.size.height-15);
//        self.topView = topView;
//        self.imgV.hidden = NO;
//        [imgV addSubview:topView];
//        
//        [[UIApplication sharedApplication].keyWindow addSubview:imgV];
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:imgV];
//    }
//    else
//    {
//        self.bg.hidden = NO;
//        self.imgV.hidden = NO;
//    }
//    
//}

-(void)tapOnce:(UITapGestureRecognizer *)tapGes{
    self.bg.hidden = YES;
    self.imgV.hidden = YES;
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
        NSLog(@"***");
//        NSInteger sx = [User integerForKey:@"infoX"];
//        NSInteger sy = [User integerForKey:@"infoY"];
//        MBPoint point;
//        point.x = (int)sx;
//        point.y = (int)sy;
//        self.startPoint = point;
        self.mapView.worldCenter = self.startPoint;
//        [_cityBtn setTitle:_cityStr forState:UIControlStateNormal];
//        _cityNode = [_worldManger getNodeByPosition:self.startPoint];
//        _cityStr = _cityNode.chsName;
    }
    
}

- (void)mbMapView:(MBMapView *)mapView didPanStartPos:(MBPoint)pos
{
    self.currentLoc.selected = NO;
}

- (void)sendButtonOnPopView:(UIButton *)button
{
    
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
        [self.navigationController popToRootViewControllerAnimated:NO];
//        if (self.annArray != nil)
//        {
//            [self.mapView removeAnnotations:(NSArray *)self.annArray];
//            [self.annArray removeAllObjects];
//        }
    }
    self.bg.hidden = YES;
    self.imgV.hidden = YES;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        self.startPoint = info.pos;
        if (info.pos.x!=0 && info.pos.y!=0)
        {
            [self.gpsLocation stopUpdatingLocation];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
