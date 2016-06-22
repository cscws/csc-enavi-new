//
//  KCTapViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.

#import "KCTapViewController.h"
#import <iNaviCore/MBGpsLocation.h>
#import <iNaviCore/MBCircleOverlay.h>
#import <iNaviCore/MBIconOverlay.h>
#import <iNaviCore/MBMapUtils.h>
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBReverseGeocoder.h>
#import "KCNaviViewController.h"

@interface KCTapViewController ()<MBMapViewDelegate,MBGpsLocationDelegate,MBReverseGeocodeDelegate>

/**
 *  终点大头针
 */
@property (nonatomic ,strong) MBAnnotation *annotationTitle;
/**
 *  终点大头针被选中
 */
@property (nonatomic ,strong) MBAnnotation *selectAnno;
/**
 逆地理编码
 */
@property (nonatomic ,strong) MBReverseGeocoder *reverseGeocoder;

@property (nonatomic ,strong) NSMutableArray *annoArr;

@end

@implementation KCTapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    // 添加标注
    if ([self.mapView.delegate respondsToSelector:@selector(mbMapView:onAnnotationClicked:area:)]) {
        CGPoint pivot = {0.5,0.5};
        self.annotationTitle = [[MBAnnotation alloc]initWithZLevel:1 pos:self.endPoint iconId:40000 pivot:pivot];
        //[self.mapView.delegate mbMapView:self.mapView onAnnotationClicked:self.annotationTitle area:MBAnnotationArea_rightButton];
        [self.mapView addAnnotation:self.annotationTitle];
        NSLog(@"onAnnotationClicked");
    }
    [self setNavigationBarWithTitle:@"地图点选"];
        self.reverseGeocoder = [[MBReverseGeocoder alloc] init];
        self.reverseGeocoder.mode = MBReverseGeocodeMode_online;
//    MBPoint point;
//    NSInteger sx = [User integerForKey:@"infoX"];
//    NSInteger sy = [User integerForKey:@"infoY"];
//    point.x = (int)sx;
//    point.y = (int)sy;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.mapView.worldCenter = self.startPoint;
}

- (NSMutableArray *)annoArr
{
    if(_annoArr==nil)
    {
        _annoArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _annoArr;
}

//-(void)mbMapView:(MBMapView *)mapView onPoiSelected:(NSString *)name pos:(MBPoint)pos
//{
//   
//}

- (void)mbMapView:(MBMapView *)mapView onTapped:(NSInteger)tapCount pos:(MBPoint)pos
{
    if(self.annoArr.count<=1)
    {

        if(self.annoArr.count==0)
        {
    MBPoint point = [self.mapView screen2World:pos];
    self.reverseGeocoder.delegate = self;
    //    if (self.annoArr.count!=0)
    //    {
    //        [self.mapView removeAnnotations:(NSArray *)self.annoArr];
    //        [self.annoArr removeAllObjects];
    //    }
    self.endPoint = point;
    [self.mapView setWorldCenter:point animated:YES];
    CGPoint pivotPoint = {0.5,1};
    // 创建新的大头针
    self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:point iconId:10002 pivot: pivotPoint];
    
    [self.mapView addAnnotation:self.annotationTitle];
    [self.reverseGeocoder reverseByPoint:&point];
    //self.selectAnno = self.annotationTitle;
    [self.annoArr addObject:self.annotationTitle];
    MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
    calloutStyle.anchor.x = 0.5f;
    calloutStyle.anchor.y = 0;
    self.annotationTitle.calloutStyle = calloutStyle;
    self.annotationTitle.title = @"加载中..";
    [self.annotationTitle showCallout:YES];
        }
        else
        {
            MBPoint point = [self.mapView screen2World:pos];
            self.reverseGeocoder.delegate = self;
            //    if (self.annoArr.count!=0)
            //    {
            //        [self.mapView removeAnnotations:(NSArray *)self.annoArr];
            //        [self.annoArr removeAllObjects];
            //    }
            self.endPoint = point;
          //  [self.mapView setWorldCenter:point animated:YES];
            CGPoint pivotPoint = {0.5,1};
            // 创建新的大头针
            self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:point iconId:10002 pivot: pivotPoint];
            
          //  [self.mapView addAnnotation:self.annotationTitle];
            [self.reverseGeocoder reverseByPoint:&point];
            //self.selectAnno = self.annotationTitle;
            [self.annoArr addObject:self.annotationTitle];
            MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
            calloutStyle.anchor.x = 0.5f;
            calloutStyle.anchor.y = 0;
            self.annotationTitle.calloutStyle = calloutStyle;
            self.annotationTitle.title = @"加载中..";
            [self.annotationTitle showCallout:YES];
        }
    }
    else
    {
//            if (self.annoArr.count!=0)
//            {
                [self.mapView removeAnnotations:(NSArray *)self.annoArr];
                [self.annoArr removeAllObjects];
         //   }
        MBPoint point = [self.mapView screen2World:pos];
        self.reverseGeocoder.delegate = self;
        //    if (self.annoArr.count!=0)
        //    {
        //        [self.mapView removeAnnotations:(NSArray *)self.annoArr];
        //        [self.annoArr removeAllObjects];
        //    }
        self.endPoint = point;
        [self.mapView setWorldCenter:point animated:YES];
        CGPoint pivotPoint = {0.5,1};
        // 创建新的大头针
        self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:point iconId:10002 pivot: pivotPoint];
        
        [self.mapView addAnnotation:self.annotationTitle];
        [self.reverseGeocoder reverseByPoint:&point];
        //self.selectAnno = self.annotationTitle;
        [self.annoArr addObject:self.annotationTitle];
        MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
        calloutStyle.anchor.x = 0.5f;
        calloutStyle.anchor.y = 0;
        self.annotationTitle.calloutStyle = calloutStyle;
        self.annotationTitle.title = @"加载中..";
        [self.annotationTitle showCallout:YES];
    }
//    if (self.selectAnno != nil)
//    {
//        [self.mapView removeAnnotation:self.selectAnno];
//    }
//    
//    self.endPoint = pos;
//    [self.mapView setWorldCenter:pos animated:YES];
//    CGPoint pivotPoint = {0.5,1};
//    
//    // 创建新的大头针
//    self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:pos iconId:10002 pivot: pivotPoint];
//    MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
//    calloutStyle.anchor.x = 0.5f;
//    calloutStyle.anchor.y = 0;
//    self.annotationTitle.calloutStyle = calloutStyle;
//    self.annotationTitle.title = @"地图点选";
//    [self.mapView addAnnotation:self.annotationTitle];
//    [self.annotationTitle showCallout:YES];
//    self.selectAnno = self.annotationTitle;
    
}

//- (void)mbMapViewOnLongPress:(MBMapView *)mapView pos:(MBPoint)pos
//{
//    self.reverseGeocoder.delegate = self;
//    if (self.selectAnno != nil)
//    {
//        [self.mapView removeAnnotation:self.selectAnno];
//    }
//    
//    self.endPoint = pos;
//    [self.mapView setWorldCenter:pos animated:YES];
//        CGPoint pivotPoint = {0.5,1};
//    // 创建新的大头针
//    self.annotationTitle = [[MBAnnotation alloc] initWithZLevel:1 pos:pos iconId:10002 pivot: pivotPoint];
//    [self.mapView addAnnotation:self.annotationTitle];
//    [self.reverseGeocoder reverseByPoint:&pos];
//    self.selectAnno = self.annotationTitle;
//}


//-(void)mbMapView:(MBMapView *)mapView onPoiDeselected:(NSString *)name pos:(MBPoint)pos
//{
//    NSLog(@"不写会崩");
//}
/**
 *  点击大头针的某区域
 */
-(void)mbMapView:(MBMapView *)mapView onAnnotationClicked:(MBAnnotation *)annot area:(MBAnnotationArea)area{
    NSLog(@"***");
    [annot showCallout:YES];
//    CGPoint point;
//    point.x = annot.position.x;
//    point.y = annot.position.y;
//    NSValue *poiValue = [NSValue valueWithCGPoint:point];
//    NSDictionary *dict = @{@"poi":poiValue};
    
    [self startN:self.endPoint];
   
    
  // [self.navigationController popViewControllerAnimated:YES];
}



/**
 *  点击位置
 *  @param  clickArea 点击区域
 *  @return 空
 */

//- (void)mbMapViewOnLongPress:(MBMapView *)mapView pos:(MBPoint)pos
//{
//[self startN:self.endPoint];
//}

-(void)startN:(MBPoint)endPoint{
    
    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = self.startPoint;
    navi.endPoint = endPoint;
    // 选择导航模式的 index
    navi.index = 0;
    [self.navigationController pushViewController:navi animated:YES];
}

/**
 *  逆地理成功
 *
 *  @param rgObject 返回逆地理对象MBReverseGeocodeObject。
 */
-(void)reverseGeocodeEventSucc:(MBReverseGeocodeObject*)rgObject
{
//    MBCalloutStyle calloutStyle = self.annotationTitle.calloutStyle;
//    calloutStyle.anchor.x = 0.5f;
//    calloutStyle.anchor.y = 0;
//    self.annotationTitle.calloutStyle = calloutStyle;
    self.annotationTitle.title = rgObject.poiName;
//    [self.annotationTitle showCallout:YES];
    
  //  [self startN:self.endPoint];
}
/**
 *  逆地理失败
 *
 *  @param err MBReverseGeocodeError类型错误信息
 */
-(void)reverseGeocodeEventFailed:(MBReverseGeocodeError)err
{
    [SVProgressHUD showInfoWithStatus:@"地理编码失败"];
}

- (void)dealloc
{
    self.mapView.delegate = nil;
    self.gpsLocation.delegate = nil;
    self.reverseGeocoder.delegate = nil;
    self.reverseGeocoder = nil;
}

@end
