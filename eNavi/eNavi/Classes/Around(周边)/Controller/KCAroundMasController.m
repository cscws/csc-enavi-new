//
//  KCAroundMasController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/18.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCAroundMasController.h"
#import <iNaviCore/MBPoiQuery.h>
#import "AroundBtn.h"
#import "SearchTool.h"
#import "DetailModel.h"
#import "DetailFrameModel.h"
#import "KCSearchResultController.h"
#import "JZSearchBar.h"
#import "KCWebViewControler.h"
#import "leftBtn.h"
#define padding 5
#define leftBtnW  70
#define leftBtnH  80

@interface KCAroundMasController ()<MBPoiQueryDelegate>
@property (nonatomic ,weak) UIView *headerView;
@property (nonatomic ,weak) UIScrollView *backScroview;
@property (nonatomic ,weak) UIButton *xicheBtn;
@property (nonatomic ,weak) UIView *baseView;
@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIView *jiayouzhanView;
@property (nonatomic ,weak) UIView *jiudianView;
@property (nonatomic ,weak) UIView *meishiView;
@property (nonatomic ,weak) UIView *xiuxianView;
@property (nonatomic ,weak) UIView *qicheView;
@property (nonatomic ,weak) UIView *jingquView;
@property (nonatomic ,weak) UIView *shenghuoView;
@property (nonatomic ,weak) UIView *jiaotongView;
@property (nonatomic, weak) JZSearchBar *search;
@property (nonatomic ,strong) MBPoiQuery *poiQury;
@property (nonatomic ,strong) NSMutableArray *resultArr;
@property (nonatomic ,strong) KCSearchResultController *searchR;
@property (nonatomic ,copy) NSString *searchStr;
@end

@implementation KCAroundMasController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self addScroView];
    [self setNavigationBar];
    [self addheaderBtnView];
    _poiQury = [MBPoiQuery sharedInstance];
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_online;
    params.searchRange = 5000;
    _poiQury.params = params;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//       //页面加载慢,临时处理
//        dispatch_async(dispatch_get_main_queue(), ^{
    
            self.jiayouzhanView.backgroundColor = kLineClor;
            self.jiudianView.backgroundColor = kLineClor;
            self.xiuxianView.backgroundColor = kLineClor;
            self.qicheView.backgroundColor = kLineClor;
            self.jingquView.backgroundColor = kLineClor;
            self.shenghuoView.backgroundColor = kLineClor;
            self.jiaotongView.backgroundColor = kLineClor;
            self.meishiView.backgroundColor = kLineClor;
//        });
//    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (NSMutableArray *)resultArr
{
    if (_resultArr==nil)
    {
        _resultArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _resultArr;
}

//- (void)setNavigationBar
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, 64)];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
//    imgView.image = [UIImage imageNamed:@"top_bkg"];
//    [view addSubview:imgView];
//    [self.view addSubview:view];
//    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 24, 40, 40);
//    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:backBtn];
//    
//    
//    CGFloat searchW = CGRectGetWidth(backBtn.frame);
//    CGFloat searchX = CGRectGetMaxX(backBtn.frame);
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.frame = CGRectMake(searchX, 29, view.frame.size.width-2*searchW-5, 30);
//    titleLabel.text = @"周边";
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:titleLabel];
//    
//}

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
    rightBtn.backgroundColor =[UIColor colorWithRed:92/255 green:170/255 blue:225/255 alpha:0.3];   [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:rightBtn];
}


- (void)addScroView
{
    UIScrollView *backScroView = [[UIScrollView alloc] init];
    backScroView.showsHorizontalScrollIndicator = NO;
    backScroView.showsVerticalScrollIndicator = NO;
    backScroView.frame = self.view.bounds;
    backScroView.backgroundColor = kVCViewcolor;
    [self.view addSubview:backScroView];
    backScroView.contentSize = CGSizeMake(self.view.width, 970);
    self.backScroview = backScroView;
}

- (void)addheaderBtnView
{
    NSArray *imgStr = @[@"btn_gas_station_s_n",@"btn_hotel_n",@"btn_food_n",@"btn_bank_n",@"btn_restroom_n",@"btn_park_s_n",@"btn_market_n",@"btn_scenic_n"];
    NSArray *sImgStr = @[@"btn_gas_station_s_p",@"btn_hotel_p",@"btn_food_p",@"btn_bank_p",@"btn_restroom_p",@"btn_park_s_p",@"btn_market_p",@"btn_scenic_p"];
    NSArray *name = @[@"加油站",@"酒店",@"美食",@"银行",@"找厕所",@"停车场",@"超市",@"景区"];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [_backScroview addSubview:headerView];
    headerView.frame = CGRectMake(5, 55, kMainScreenSizeWidth-10, 140);
    self.headerView = headerView;
    NSInteger col = 4;
    for (int i=0;i<8;i++)
    {
        AroundBtn *button = [AroundBtn buttonWithType:UIButtonTypeCustom];
        button.height = headerView.height/2;
        button.width = headerView.width/4;
        button.x = (i%col)*(button.width);
        button.y = (i/col)*(button.height);
        [self setHeaderViewBtn:button withImage:imgStr[i] selectImg:sImgStr[i] btnName:name[i]];
        [headerView addSubview:button];
    }
    [self addQuxicheBtn];
}
- (void)addQuxicheBtn
{
    CGFloat Y = CGRectGetMaxY(_headerView.frame)+0.5;
    UIButton *xicheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setsubBtn:xicheBtn Tiltle:@"去洗车" imageName:@"car_coupon.png"];
    xicheBtn.frame = CGRectMake(5, Y, kMainScreenSizeWidth-10, 40);
    [_backScroview addSubview:xicheBtn];
    self.xicheBtn = xicheBtn;
}


//加油站
- (UIView *)jiayouzhanView
{
if (!_jiayouzhanView)
{
    CGFloat y = CGRectGetMaxY(_xicheBtn.frame)+5;
    
    [self setLeftBtnWith:@"searAroundGas" btnName:@"加油站" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(110, 191, 249, 1)];
    NSArray *arr = @[@"中国石油",@"中国石化",@"加气站"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70,y ,kMainScreenSizeWidth-75 , leftBtnH)];
    _jiayouzhanView = view;
    _jiayouzhanView.backgroundColor = kVCViewcolor;
    [self calFrameWithColumn:2 row:2 allCount:arr.count nameArr:arr baseView:_jiayouzhanView];
    [_backScroview addSubview:view];
}
    return _jiayouzhanView;
}


//酒店住宿
- (UIView *)jiudianView
{
    if(!_jiudianView)
    {
    CGFloat y = CGRectGetMaxY(_jiayouzhanView.frame)+5;
    [self setLeftBtnWith:@"searAroundHotel" btnName:@"酒店" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(152, 142, 252, 1)];
        NSArray *arr = @[@"连锁酒店",@"星级酒店",@"旅店",@"农家乐",@"度假村"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70,y ,kMainScreenSizeWidth-75 , 80)];
        _jiudianView = view;
        [self calFrameWithColumn:3 row:2 allCount:arr.count nameArr:arr baseView:_jiudianView];
    [_backScroview addSubview:view];
    
    }
    return _jiudianView;
}


//休闲娱乐
- (UIView *)xiuxianView
{
    if (!_xiuxianView)
    {
    CGFloat y = CGRectGetMaxY(_jiudianView.frame)+5;
    
    [self setLeftBtnWith:@"searAroundCinema" btnName:@"休闲" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(244, 183, 77, 1)];
    NSArray *arr = @[@"电影院",@"KTV",@"酒吧",@"咖啡厅",@"游乐园",@"商场"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, y,kMainScreenSizeWidth-75,80)];
    _xiuxianView = view;
    
    [self calFrameWithColumn:3 row:2 allCount:arr.count nameArr:arr baseView:_xiuxianView];
    [_backScroview addSubview:_xiuxianView];
    }
    return _xiuxianView;
}

//汽车服务
- (UIView *)qicheView
{
    if (!_qicheView)
    {
    CGFloat y = CGRectGetMaxY(_xiuxianView.frame)+5;
    [self setLeftBtnWith:@"searAroundCar" btnName:@"汽车" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(129, 208, 221, 1)];
        NSArray *arr = @[@"停车场",@"汽车维修",@"汽车美容",@"租车",@"汽车销售"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70,y ,kMainScreenSizeWidth-75 , 80)];
        _qicheView = view;
        [self calFrameWithColumn:3 row:2 allCount:arr.count nameArr:arr baseView:_qicheView];
    [_backScroview addSubview:view];
    }
    return _qicheView;
}

//景区
- (UIView *)jingquView
{
    if (!_jingquView)
    {
    CGFloat y = CGRectGetMaxY(_qicheView.frame)+5;
    [self setLeftBtnWith:@"searAroundLandscape" btnName:@"景区" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(145 , 230, 141, 1)];
    NSArray *arr = @[@"名胜古迹",@"博物馆",@"动植物园",@"公园"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, y,kMainScreenSizeWidth-75,80)];
    _jingquView = view;
    
    [self calFrameWithColumn:2 row:2 allCount:arr.count nameArr:arr baseView:_jingquView];
     [_backScroview addSubview:_jingquView];
    }
    return _jingquView;
}
//生活服务
- (UIView *)shenghuoView
{
    if(!_shenghuoView)
    {
    CGFloat y = CGRectGetMaxY(_jingquView.frame)+5;
    [self setLeftBtnWith:@"searAroundService" btnName:@"生活" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(239 , 163, 144, 1)];
    NSArray *arr = @[@"厕所",@"ATM/银行",@"电信营业厅",@"药店",@"医院",@"超市"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, y,kMainScreenSizeWidth-75,80)];
    _shenghuoView = view;
    [self calFrameWithColumn:3 row:2 allCount:arr.count nameArr:arr baseView:_shenghuoView];
    [_backScroview addSubview:_shenghuoView];
    }
    return _shenghuoView;
}

//交通出行
- (UIView *)jiaotongView
{
    if (!_jiaotongView)
    {
    CGFloat y = CGRectGetMaxY(_shenghuoView.frame)+5;
    [self setLeftBtnWith:@"searAroundTraffic" btnName:@"交通" frame:CGRectMake(5, y, leftBtnW, leftBtnH) fontColor:kColor(124, 173, 251, 1)];
    NSArray *arr = @[@"公交车站",@"地铁站",@"火车站",@"长途汽车站"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, y,kMainScreenSizeWidth-75,80)];
    _jiaotongView = view;
    [self calFrameWithColumn:2 row:2 allCount:arr.count nameArr:arr baseView:_jiaotongView];
    [_backScroview addSubview:_jiaotongView];
    }
    return _jiaotongView;
}
//美食
- (UIView *)meishiView
{
    if (!_meishiView)
    {
    CGFloat y = CGRectGetMaxY(_jiaotongView.frame)+5;
        [self setLeftBtnWith:@"searAroundFood" btnName:@"美食" frame:CGRectMake(5, y, leftBtnW, 120) fontColor:kColor(239, 163, 109, 1)];
    NSArray *arr = @[@"中餐厅",@"小吃快餐",@"特色餐厅",@"火锅",@"川菜",@"日韩料理",@"西餐",@"甜点",@"K记/M记"];
        
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, y,kMainScreenSizeWidth-75,120)];
    _meishiView = view;
    [self calFrameWithColumn:3 row:3 allCount:arr.count nameArr:arr baseView:_meishiView];
    [_backScroview addSubview:_meishiView];
    }
    return _meishiView;
}


- (void)setLeftBtnWith:(NSString *)name btnName:(NSString *)btnNm frame:(CGRect)frame fontColor:(UIColor *)color;
{
   
    leftBtn *Btn = [leftBtn buttonWithType:UIButtonTypeCustom];
    Btn.frame = frame;
    Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    Btn.titleLabel.font = font(12.0);
    [Btn setTitleColor:color forState:UIControlStateNormal];
    [Btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [Btn setTitle:btnNm forState:UIControlStateNormal];
    Btn.backgroundColor = [UIColor whiteColor];
    [Btn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backScroview addSubview:Btn];
}


- (void)calFrameWithColumn:(NSInteger)col row:(NSInteger)row allCount:(NSInteger)count nameArr:(NSArray *)arr baseView:(UIView *)view;
{
    for(int i=0;i<count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.height = (view.frame.size.height - 0.5)/row;
        if ((arr.count==5) && (i/col)==1)
        {
            button.width = view.frame.size.width/2;
        }else if ((arr.count==3)&&(i/col)==1)
        {
        button.width = view.frame.size.width;
        }
        else
        {
            button.width = view.frame.size.width/col;
        }
        button.x = (i%col)*(button.width + 0.5)+0.5;
        button.y = (i/col)*(button.height + 0.5);
        [self setsubBtn:button Tiltle:arr[i] imageName:nil];
        [view addSubview:button];
        
    }
 
}


- (void)setsubBtn:(UIButton *)Btn Tiltle:(NSString *)title imageName:(NSString *)imgStr
{
    Btn.backgroundColor = [UIColor whiteColor];
    Btn.titleLabel.font = font(14.0);
    [Btn setTitle:title forState:UIControlStateNormal];
    [Btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    if(imgStr != nil)
    {
    [Btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    [Btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)headerViewBtnClicked:(UIButton *)btn
{
    
       _searchStr = btn.currentTitle;
    self.poiQury.delegate = self;
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
    if ([_searchStr isEqualToString:@"加油站"])
    {
  
//        _centerPoi.x = (int)12153824;
//        _centerPoi.y = (int)3112844;
        MBPoiTypeIndex indexxx[] = {0x0101};
        [self.poiQury queryNearbyByPoiTypes:_centerPoi poiTypeIndexs: indexxx length:1];
    }
    else
    {
       [self.poiQury queryText:[btn currentTitle] center:_centerPoi isNearby:YES];
    }
}

- (void)btnclick:(UIButton *)btn
{
    [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        if([btn.currentTitle isEqualToString:@"去洗车"])
        {
            KCWebViewControler *info = [[KCWebViewControler alloc] init];
            info.controllerType = @"车小秘";
            [self.navigationController pushViewController:info animated:YES];
        }
        else
        {
            _searchStr = btn.currentTitle;
            self.poiQury.delegate = self;

            [SearchTool searchWithStr:[btn currentTitle] search:^(MBPoiTypeIndex result[],int count) {
                [self.poiQury queryNearbyByPoiTypes:_centerPoi poiTypeIndexs:result length:count];
            }];
        }

     //       [hud hideAnimated:YES afterDelay:1];
}


- (void)leftBtnClicked:(UIButton *)btn
{
    
    self.poiQury.delegate = self;
    
    NSString *str = [btn currentTitle];
    _searchStr = str;
    
    if ([str isEqualToString:@"加油站"])
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        
       MBPoiTypeIndex indexxx[] = {0x0101};
       [self.poiQury queryNearbyByPoiTypes:_centerPoi poiTypeIndexs: indexxx length:1];
    }
    else if ([str isEqualToString:@"酒店"]||[str isEqualToString:@"美食"]||[str isEqualToString:@"休闲"])
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        
        [self.poiQury queryText:str center:_centerPoi isNearby:YES];
    //关键字搜索
    }
    else if ([str isEqualToString:@"搜索"])
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        
        [_search resignFirstResponder];
        if(_search.text == nil)
        {
        [SVProgressHUD showInfoWithStatus:@"请设置关键字"];
        }
        else
        {
        [self.poiQury queryText:_search.text center:_centerPoi isNearby:YES];
        }
    
    }
   //剩余不可点
    
}

- (void)setHeaderViewBtn:(AroundBtn *)Btn withImage:(NSString *)imgStr selectImg:(NSString *)sImgStr btnName:(NSString *)name
{
    Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    Btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    Btn.backgroundColor = [UIColor whiteColor];
    [Btn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    [Btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [Btn setImage:[UIImage imageNamed:sImgStr] forState:UIControlStateHighlighted];
    [Btn setTitle:name forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(headerViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}



-(void)poiQueryFailed{
   
    [SVProgressHUD showInfoWithStatus:@"搜索失败"];
}
-(void)poiQueryNoResult{

    [SVProgressHUD showInfoWithStatus:@"没有结果"];
}

/**
 *  搜索分页结果回调
 *  @param  result    poi搜索结果 [MBPoiFavorite](#)
 */
- (void)poiQueryResultByPage:(NSArray *)result
{
    
 //   if (self.resultArr.count!=0)[self.resultArr removeAllObjects];
    self.resultArr = (NSMutableArray *)result;
//    NSInteger i=0;
//        for (MBPoiFavorite *favorPoi in result)
//        {
//            NSLog(@"+++++++++%@",favorPoi.name);
//            DetailModel *model = [[DetailModel alloc] init];
//            DetailFrameModel *detailFrameModel = [[DetailFrameModel alloc] init];
//            model.name = favorPoi.name;
//            model.address = favorPoi.address;
//            model.distance = favorPoi.distance;
//            model.poi = favorPoi.pos;
//            model.phoneNumber = favorPoi.phoneNumber;
//            model.icon = @"poi";
//            model.i = ++i;
//            detailFrameModel.model = model;
//            [self.resultArr addObject:detailFrameModel];
//        }
            [SVProgressHUD dismissAfterDuration:1.0];
    if(result.count>0)
    {
        NSLog(@"%lu",(unsigned long)result.count);
    [self jumpToOtherViewController];
        
    }
}

- (void)jumpToOtherViewController
{
    
    KCSearchResultController *searchR = [[KCSearchResultController alloc] init];
    searchR.resultList = self.resultArr;
    searchR.vcClass = self.class;
    searchR.startPoint = self.startPoi;
 //   searchR.poiQ = _poiQury;
    searchR.titleStr = _searchStr;
    [self.navigationController pushViewController:searchR animated:YES];
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
