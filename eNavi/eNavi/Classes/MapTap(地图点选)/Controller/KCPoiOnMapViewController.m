//
//  KCPoiOnMapViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/5/16.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCPoiOnMapViewController.h"
#import <iNaviCore/MBReverseGeocoder.h>
#import "DetailFrameModel.h"
#import "DetailModel.h"
#import "KCPoiDetailViewController.h"
#import "KCNaviViewController.h"

@interface KCPoiOnMapViewController ()<MBReverseGeocodeDelegate>
@property (nonatomic, strong) MBReverseGeocoder *reverseGeocoder;
@property (nonatomic, strong) MBAnnotation *annotation;
@property (nonatomic, strong) NSMutableArray *annArray;
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation KCPoiOnMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBarWithTitle:_titleStr];
    [self addDeleteBtn];
    [self addPoiOnMapView];
}

- (NSMutableArray *)annArray
{
    if (_annArray == nil)
    {
        _annArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _annArray;
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
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = CGRectMake(kMainScreenSizeWidth-40, 26, 40, 40);
    [listBtn setImage:[UIImage imageNamed:@"travei_rout_jump"] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(backToSearchResultVIewcontroller) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:listBtn];
}

- (void)addDeleteBtn
{
    CGFloat btnW = 40;
    CGFloat btnH = 40;
    CGFloat btnX = kMainScreenSizeWidth-50;

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(btnX, 94, btnW, btnH);
    [deleteBtn setImage:[UIImage imageNamed:@"search_result_delete_n"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"search_result_delete_p"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(jumpToRootViewController) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = deleteBtn;
    [self.view addSubview:deleteBtn];

}

- (void)addPoiOnMapView
{
    for (int i=0;i<_poiArray.count;i++)
    {
        MBPoiFavorite *fav = _poiArray[i];
        MBPoint point = fav.pos;
        CGPoint pivotPoint = {0, 0};
        CGPoint strPoint = {0.48, 0.4};
        MBAnnotation* annotation = [[MBAnnotation alloc] initWithZLevel:2 pos:point iconId:3001 pivot: pivotPoint];
        [annotation setIconText:[NSString stringWithFormat:@"%d",i+1] UIColor:kNaviColor anchor:strPoint];
        annotation.title = fav.name;
        annotation.subTitle = fav.address;
        [self.mapView addAnnotation:annotation];
        [self.annArray addObject:annotation];
        
        if (i==0)
        {
            _titleStr = fav.name;
            self.mapView.worldCenter = point;
            MBCalloutStyle calloutStyle = annotation.calloutStyle;
            calloutStyle.anchor.x = 0.5f;
            calloutStyle.anchor.y = 0.2;
            calloutStyle.leftIcon = 101;
            calloutStyle.rightIcon = 102;
            //    calloutStyle.titleColor = 0xFFFFFF;
            //    calloutStyle.subtitleColor = 0xFFFFFF;
            annotation.calloutStyle = calloutStyle;
            [annotation showCallout:YES];
        }
    }
}

-(void)mbMapView:(MBMapView *)mapView onAnnotationSelected:(MBAnnotation *)annot
{
    MBPoint point = annot.position;
    self.annotation = annot;
    [self.mapView setWorldCenter:point animated:YES];
  
    MBCalloutStyle calloutStyle = self.annotation.calloutStyle;
    calloutStyle.anchor.x = 0.5f;
    calloutStyle.anchor.y = 0.2;
    calloutStyle.leftIcon = 101;
    calloutStyle.rightIcon = 102;
//    calloutStyle.titleColor = 0xFFFFFF;
//    calloutStyle.subtitleColor = 0xFFFFFF;
    self.annotation.calloutStyle = calloutStyle;
    [self.annotation showCallout:YES];
    
}

-(void)mbMapView:(MBMapView *)mapView onAnnotationClicked:(MBAnnotation *)annot area:(MBAnnotationArea)area{
    if (area == 4) {
        [self startN:_annotation.position];
    }
    else if (area == 3)
    {
        KCPoiDetailViewController *detail = [storyB instantiateViewControllerWithIdentifier:@"poiDetail"];
        detail.name = _annotation.title;
        detail.address = _annotation.subTitle;
        detail.startPoi = self.startPoint;
        detail.endPoi = _annotation.position;
        //self.poiDetail = detail;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

-(void)startN:(MBPoint)endPoint{

    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = self.startPoint;
    NSLog(@"%d",self.startPoint.x)
    navi.endPoint = endPoint;
    // 选择导航模式的 index
    navi.index = 0;
    [self.navigationController pushViewController:navi animated:YES];
}


- (void)jumpToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)backToSearchResultVIewcontroller
{
   
    CATransition *animation1=[CATransition animation];
  //  animation1.duration=1;
    animation1.type=@"Fade";
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.navigationController.view.layer addAnimation:animation1 forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
