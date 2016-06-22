//
//  KCNaviDetailViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCNaviDetailViewController.h"
#import <iNaviCore/MBReverseGeocoder.h>
#import "KCBtn.h"
#import "KCTapViewController.h"
#import "KCNaviViewController.h"
#import "KCCityListViewController.h"
#import "KCSearchNaviDetailController.h"
#import "naviDetailHisCell.h"
#import "NaviDetailHisModel.h"
#import "KCPoiDetailViewController.h"
#import "miShuView.h"
#import "KCSearchViewController.h"

@interface KCNaviDetailViewController ()<MBReverseGeocodeDelegate,KCCityListViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,miShuViewDelegate>
@property (nonatomic, weak)KCBtn *kcBtn;
@property (nonatomic, weak)UIView *btnView;
@property (nonatomic, weak)UIButton *homeNameBtn;
@property (nonatomic, weak)UIButton *companyNameBtn;
@property (nonatomic, weak)UIButton *cityBtn;
@property (nonatomic, weak)UIView *backScroView;
@property (nonatomic, weak)UIView *bgView;
@property (nonatomic, weak)UIView *mishuView;
@property (nonatomic, strong)KCTapViewController *tapMap;
//@property (nonatomic, strong)MBReverseGeocoder *reverseGeocoder;
@property (nonatomic, strong)NSDictionary *poiDict;
@property (nonatomic, strong)NSMutableArray *histArr;
@property (nonatomic, assign)MBPoint homePoi;
@property (nonatomic, assign)MBPoint companyPoi;
@property (nonatomic, weak)UITableView *hisTableview;

@property (nonatomic, copy)NSString *type;

@end

@implementation KCNaviDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHomeBtnTitle:) name:kChangeHomeButtonTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanyBtnTitle:) name:kChangeCompanyButtonTitle object:nil];
    [self.hisTableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    self.navigationController.navigationBar.hidden = NO;
    _poiDict = [NSDictionary dictionary];
    [self addSubViews];
    [self setNavigationBar];
    [self addSecretaryNotify];
    //[self addSubViews];
    
//    self.reverseGeocoder = [[MBReverseGeocoder alloc] init];
//    self.reverseGeocoder.mode = MBReverseGeocodeMode_online;
}

- (NSMutableArray *)histArr
{
    if(_histArr == nil)
    {
        _histArr = [NSKeyedUnarchiver unarchiveObjectWithFile:NaviDetailHisFilePath];
        if (_histArr == nil)
        {
            _histArr = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return _histArr;
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
    backBtn.frame = CGRectMake(0, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    CGFloat searchW = CGRectGetWidth(backBtn.frame);
    CGFloat searchX = CGRectGetMaxX(backBtn.frame);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(searchX, 29, view.frame.size.width-2*searchW-5, 30);
    titleLabel.text = @"导航";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];

}

- (void)addSubViews
{
    CGFloat pading = 5.0;
  
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(pading, 69, kMainScreenSizeWidth-2*pading, 39)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView.layer setMasksToBounds:YES];
    [searchView.layer setCornerRadius:2];
    searchView.layer.borderWidth = 0.5;
    searchView.layer.borderColor = kLayerBorderColor;
    [self.view addSubview:searchView];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(pading, 5, 60, 29);
    [cityBtn.layer setMasksToBounds:YES];
    [cityBtn.layer setCornerRadius:2.0];
    cityBtn.backgroundColor = [UIColor colorWithRed:85.0/255 green:185.0/255 blue:234.0/255 alpha:1];
    cityBtn.titleLabel.font = font(14.0);
    [cityBtn setTitle:_cityName forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(jumpToCityVC) forControlEvents:UIControlEventTouchUpInside];
    self.cityBtn = cityBtn;
    [searchView addSubview:cityBtn];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   // seachBtn.backgroundColor = [UIColor redColor];
    CGFloat seachX = CGRectGetMaxX(cityBtn.frame);
    seachBtn.frame = CGRectMake(seachX, 0, kMainScreenSizeWidth-105, 39);
//    seachBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [seachBtn addTarget:self action:@selector(jumpToSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:seachBtn];
    
    CGFloat backViewY = CGRectGetMaxY(searchView.frame);
    UIView *backScroView = [[UIView alloc] init];
    //backScroView.frame = CGRectMake(0, 0, kMainScreenSizeWidth-2*pading, 400);
    backScroView.backgroundColor = kVCViewcolor;
   // [self.view addSubview:backScroView];
    self.backScroView = backScroView;
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kMainScreenSizeWidth-2*pading, 80)];
    CGFloat btnViewH = CGRectGetHeight(btnView.frame);
    btnView.backgroundColor = [UIColor whiteColor];
    [btnView.layer setMasksToBounds:YES];
    [btnView.layer setCornerRadius:2];
    btnView.layer.borderWidth = 0.5;
    btnView.layer.borderColor = kLayerBorderColor;
    self.btnView = btnView;
    [self.backScroView addSubview:_btnView];
    for (int i=0;i<2;i++)

    {
        NSArray *arr = @[@"导航秘书",@"地图点选",@"收藏夹"];
        for(int i=0;i<3;i++)
        {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake((i+1)*(kMainScreenSizeWidth/3), 5, 1, btnViewH-10);
            lineView.backgroundColor = kLineClor;
           KCBtn *kcBtn = [KCBtn buttonWithType:UIButtonTypeCustom];
            kcBtn.frame = CGRectMake(i*(kMainScreenSizeWidth/3), 0, ((kMainScreenSizeWidth-2*pading)/3), 80);
            kcBtn.tag = i+10;
            //btn.backgroundColor = MPColor(arc4random()%255, arc4random()%255, arc4random()%255);
            [kcBtn setTitle:[NSString stringWithFormat:@"%@",arr[i]] forState:UIControlStateNormal];
            kcBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            kcBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [kcBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
            [kcBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kcBtn_%d",i+1]] forState:UIControlStateNormal];
            [kcBtn addTarget:self action:@selector(btnClickedWithTag:) forControlEvents:UIControlEventTouchDown];
            self.kcBtn = kcBtn;
            [_btnView addSubview:lineView];
            [_btnView addSubview:kcBtn];
        }
    }
   
   CGFloat offenUseLabelY = CGRectGetMaxY(_btnView.frame);
    UILabel *offenUseLabel = [[UILabel alloc] initWithFrame:CGRectMake(pading, offenUseLabelY+5, 60, 20)];
    offenUseLabel.text = @"常用地点";
    offenUseLabel.font = [UIFont systemFontOfSize:12.0];
    offenUseLabel.textColor = kTextFontColor;
    [self.backScroView addSubview:offenUseLabel];
    
    CGFloat offenViewY = CGRectGetMaxY(offenUseLabel.frame);
    UIView *offenView = [[UIView alloc] initWithFrame:CGRectMake(0, offenViewY, kMainScreenSizeWidth-2*pading, 120)];
    offenView.backgroundColor = [UIColor whiteColor];
    [offenView.layer setMasksToBounds:YES];
    [offenView.layer setCornerRadius:2];
    offenView.layer.borderWidth = 0.5;
    offenView.layer.borderColor = kLayerBorderColor;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, offenView.frame.size.height/2, offenView.frame.size.width, 1)];
    line.backgroundColor = kLineClor;
    [offenView addSubview:line];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setImage:[UIImage imageNamed:@"btn_home"] forState:UIControlStateNormal];
   // homeButton.backgroundColor = [UIColor redColor];
    homeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [homeButton setTitle:@"回家" forState:UIControlStateNormal];
    homeButton.titleLabel.font = font(17.0);
    [homeButton setTitleColor:kTextFontColor forState:UIControlStateNormal];
    homeButton.frame = CGRectMake(0, 0, 100, offenView.frame.size.height/2);
    [homeButton setUserInteractionEnabled:NO];
    [offenView addSubview:homeButton];
    
    UIButton *homeNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[homeNameBtn setTitle:@"绿地香颂" forState:UIControlStateNormal];
    [homeNameBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
//    homeNameBtn.backgroundColor =[ UIColor redColor];
    [homeNameBtn setTitle:[User objectForKey:@"homePoiName"] forState:UIControlStateNormal];
    homeNameBtn.tag = 13;
    [homeNameBtn addTarget:self action:@selector(homeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    homeNameBtn.frame = CGRectMake(0, 0, offenView.frame.size.width, offenView.frame.size.height/2);
    homeNameBtn.titleLabel.font = font(14.0);
    homeNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.homeNameBtn = homeNameBtn;
    [offenView addSubview:homeNameBtn];
    
    
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [compButton setImage:[UIImage imageNamed:@"btn_company"] forState:UIControlStateNormal];
    // homeButton.backgroundColor = [UIColor redColor];
    [compButton setTitle:@"去公司" forState:UIControlStateNormal];
    compButton.titleLabel.font = font(17.0);
    [compButton setTitleColor:kTextFontColor forState:UIControlStateNormal];
    compButton.frame = CGRectMake(0, offenView.frame.size.height/2, 100, offenView.frame.size.height/2);
    [compButton setUserInteractionEnabled:NO];
    [offenView addSubview:compButton];
    
    UIButton *companyNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyNameBtn setTitle:[User objectForKey:@"companyPoiName"] forState:UIControlStateNormal];
    [companyNameBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    companyNameBtn.tag = 14;
    [companyNameBtn addTarget:self action:@selector(homeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    companyNameBtn.frame = CGRectMake(0, offenView.frame.size.height/2, offenView.frame.size.width, offenView.frame.size.height/2);
    companyNameBtn.titleLabel.font = font(14.0);
    companyNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.companyNameBtn = companyNameBtn;
    [offenView addSubview:companyNameBtn];
    [self.backScroView addSubview:offenView];
    
    CGFloat historyLabelY = CGRectGetMaxY(offenView.frame);
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(pading, historyLabelY+5, 60, 20)];
    historyLabel.text = @"历史地点";
    historyLabel.font = font(12.0);
    historyLabel.textColor = kTextFontColor;
    [self.backScroView addSubview:historyLabel];

    CGFloat Y = CGRectGetMaxY(historyLabel.frame);
    UITableView *historyView = [[UITableView alloc] initWithFrame:CGRectMake(pading, backViewY+10, kMainScreenSizeWidth-2*pading, kMainScreenSizeHeight-backViewY)];
    self.hisTableview = historyView;
    historyView.backgroundColor = kVCViewcolor;
    historyView.tableFooterView = [[UIView alloc] init];
    [historyView.layer setMasksToBounds:YES];
    [historyView.layer setCornerRadius:2];
    historyView.layer.borderWidth = 0.5;
    historyView.layer.borderColor = kLayerBorderColor;
    historyView.delegate = self;
    historyView.dataSource = self;
    historyView.showsVerticalScrollIndicator = NO;
    _backScroView.frame = CGRectMake(0, 0, kMainScreenSizeWidth-2*pading, Y);
    historyView.tableHeaderView = _backScroView;
    [self.view addSubview:historyView];
}

- (void)homeBtnClick:(id)sender
{
    
    UIButton *thisBtn = (UIButton *)sender;
    if (thisBtn.currentTitle == nil)
    {
        KCSearchNaviDetailController *searchNaviDe = [[KCSearchNaviDetailController alloc] init];
        searchNaviDe.startPoint = self.startPoint;
        searchNaviDe.cityNode = self.cityNode;
        searchNaviDe.index = thisBtn.tag;
        [self.navigationController pushViewController:searchNaviDe animated:YES];
        
//        KCTapViewController *tapMap = [[KCTapViewController alloc] init];
//        if (thisBtn.tag==13)
//        {
//            tapMap.index = thisBtn.tag;
//        }
//        else
//        {
//            tapMap.index = thisBtn.tag;
//        }
//        [self.navigationController pushViewController:tapMap animated:YES];
    }
    else
    {
        MBPoint poi;
        NSInteger x ;
        NSInteger y ;
        KCNaviViewController *navi = [[KCNaviViewController  alloc] init];
        navi.startPoint = _startPoint;
        if (thisBtn.tag==13)
        {
            x = [User integerForKey:@"homePoix"];
            y = [User integerForKey:@"homePoiy"];
            
            poi.x = (int)x;
            poi.y = (int)y;
            navi.endPoint = poi;
            
        }
        else
        {
            x = [User integerForKey:@"companyPoix"];
            y = [User integerForKey:@"companyPoiy"];
            poi.x = (int)x;
            poi.y = (int)y;
            navi.endPoint = poi;
        }
        
        [self.navigationController pushViewController:navi animated:YES];
    }
}

- (void)changeHomeBtnTitle:(NSNotification *)noti
{
   // self.reverseGeocoder.delegate = self;
    _poiDict = noti.object;
    CGPoint poi = [_poiDict[@"poi"] CGPointValue];
    _homePoi.x = poi.x;
    _homePoi.y = poi.y;
    [_homeNameBtn setTitle:_poiDict[@"name"] forState:UIControlStateNormal];
   // [self.reverseGeocoder reverseByPoint:&_homePoi];
    _type = _poiDict[@"name"];
    
    [User setObject:_type forKey:@"homePoiName"];
    [User setInteger:_homePoi.x forKey:@"homePoix"];
    [User setInteger:_homePoi.y forKey:@"homePoiy"];
}

- (void)changeCompanyBtnTitle:(NSNotification *)noti
{
   // self.reverseGeocoder.delegate = self;
    _poiDict = noti.object;
    CGPoint poi = [_poiDict[@"poi"] CGPointValue];
    _companyPoi.x = poi.x;
    _companyPoi.y = poi.y;
    [_companyNameBtn setTitle:_poiDict[@"name"] forState:UIControlStateNormal];
  //  [self.reverseGeocoder reverseByPoint:&_companyPoi];
    _type = _poiDict[@"name"];
    [User setObject:_type forKey:@"companyPoiName"];
    [User setInteger:_companyPoi.x forKey:@"companyPoix"];
    [User setInteger:_companyPoi.y forKey:@"companyPoiy"];
}


- (void)btnClickedWithTag:(id)sender
{
    UIButton *thisBtn = (UIButton*)sender;
    if (thisBtn.tag==10)
    {
       if(self.bgView==nil && self.mishuView==nil)
       {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        self.bgView = bgView;
       // [[UIApplication sharedApplication].keyWindow addSubview:bgView];
           [self.view addSubview:bgView];
        
        //创建手势对象
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
        //点击的次数
        tap.numberOfTouchesRequired = 1;
        [self.bgView  addGestureRecognizer:tap];
        
        //透明 view 上在贴个 view
        
        miShuView *mishuView = [[miShuView alloc] init];
        mishuView.delegate  = self;
        mishuView.backgroundColor = [UIColor whiteColor];
       // mishuView.alpha = 1.0;
        // topView.userInteractionEnabled = YES;
        CGFloat x = 30;
        CGFloat w = (kMainScreenSizeWidth-2*x);
        CGFloat h = 340;
        CGFloat y = (kMainScreenSizeHeight-h)/2;
        mishuView.frame = CGRectMake(x, y, w, h);
        self.mishuView = mishuView;
        [bgView addSubview:mishuView];
        
//        [[UIApplication sharedApplication].keyWindow addSubview:mishuView];
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:mishuView];
           [self.view addSubview:mishuView];
           [self.view bringSubviewToFront:mishuView];
       }
            else
            {
                self.bgView.hidden = NO;
                self.mishuView.hidden = NO;
            }
    }


    else if (thisBtn.tag==11)
    {
        KCTapViewController *tapMap = [[KCTapViewController alloc] init];
        tapMap.index = thisBtn.tag;
        [self.navigationController pushViewController:tapMap animated:YES];
    }
    else
    {
    NSLog(@"tag==12");
    }
}

-(void)tapOnce:(UITapGestureRecognizer *)tapGes{
    self.bgView.hidden = YES;
    self.mishuView.hidden = YES;
}


- (void)jumpToCityVC
{
    KCCityListViewController *cityList = [[KCCityListViewController alloc] init];
    cityList.delegate = self;
    [self.navigationController pushViewController:cityList animated:YES];
}

- (void)jumpToSearchVC
{
//    KCSearchNaviDetailController *searchNaviDe = [[KCSearchNaviDetailController alloc] init];
//    searchNaviDe.startPoint = self.startPoint;
//    searchNaviDe.cityNode = self.cityNode;
    
    KCSearchViewController *search = [[KCSearchViewController alloc] init];
    search.VCclass = [self class];
    search.startPoint = self.startPoint;
    search.cityNode = self.cityNode;
    [self.navigationController pushViewController:search animated:YES];
}

///**
// *  逆地理成功
// *
// *  @param rgObject 返回逆地理对象MBReverseGeocodeObject。
// */
//-(void)reverseGeocodeEventSucc:(MBReverseGeocodeObject*)rgObject
//{
//
//    if ([_type isEqualToString:@"home"])
//    {
//       
//        [_homeNameBtn setTitle:rgObject.poiName forState:UIControlStateNormal];
//        
//        
//        
//    }else
//    {
//        [_companyNameBtn setTitle:rgObject.poiName forState:UIControlStateNormal];
//        
//        
//    }
//    
//}
///**
// *  逆地理失败
// *
// *  @param err MBReverseGeocodeError类型错误信息
// */
//-(void)reverseGeocodeEventFailed:(MBReverseGeocodeError)err
//{
//    [SVProgressHUD showInfoWithStatus:@"地理编码失败"];
//}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bringCityNameToKCNaviDetailWithNode:(MBWmrNode *)node cityName:(NSString *)cityName
{
    [_cityBtn setTitle:cityName forState:UIControlStateNormal];
    self.cityNode = node;
    self.nodeBlock(node);
    NSLog(@"!!!---%d",node.nodeId);
}

- (void)bringCityNode:(bringNodeBlock)block
{
    self.nodeBlock = block;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.histArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    naviDetailHisCell *cell = [naviDetailHisCell cellWithTableview:tableView];
    cell.model = self.histArr[indexPath.row];
    for(id ddd in self.histArr)
    {
        NSLog(@"%@",[ddd class]);
    }
    
    [cell btnOnCellClicked:^(NaviDetailHisModel *model) {
        KCPoiDetailViewController *poiDe = [storyB instantiateViewControllerWithIdentifier:@"poiDetail"];
        poiDe.name = model.name;
        poiDe.address = model.name;
        poiDe.phoneNumber = model.phoneNumber;
        MBPoint spoi;
        spoi.x = model.sX;
        spoi.y = model.sY;
        poiDe.startPoi = spoi;
        MBPoint epoi;
        epoi.x = model.eX;
        epoi.y = model.eY;
        poiDe.endPoi = epoi;
        [self.navigationController pushViewController:poiDe animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    NaviDetailHisModel *model = self.histArr[indexPath.row];
    MBPoint spoi;
    spoi.x = model.sX;
    spoi.y = model.sY;
    navi.startPoint = spoi;
    MBPoint epoi;
    epoi.x = model.eX;
    epoi.y = model.eY;
    navi.endPoint = epoi;
    [self.navigationController pushViewController:navi animated:YES];
}

- (void)sendButtonOnMishuView:(UIButton *)button
{
    if(self.bgView!=nil && self.mishuView!=nil)
    {
    [self.bgView removeFromSuperview];
    [self.mishuView removeFromSuperview];
    }
    if([button.currentTitle isEqualToString:@"拨打"])
    {
    NSString* url = [NSString stringWithFormat:@"telprompt://%@", @"4008841168"];
    [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:url]];
    }
    else
    {
    
    }
}

- (void)addSecretaryNotify
{
#warning 这里会调用两次
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidActive)
     name:UIApplicationDidBecomeActiveNotification
     object:NULL];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
}

- (void)applicationDidActive
{
    [self GetDestinationInfo];
    NSLog(@"applicationDidActive");
}

- (void)applicationWillResignActive
{
    NSLog(@"applicationWillResignActive");
}

- (void)GetDestinationInfo
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"-1,-1,-1" forHTTPHeaderField:@"x-up-devcap-brewlicense"];
    [manager.requestSerializer setValue:@"v1.0" forHTTPHeaderField:@"x-up-devcap-appinfo"];
    [manager.requestSerializer setValue:@"iPhone 9.3" forHTTPHeaderField:@"x-up-devcap-platform-id"];
    [manager.requestSerializer setValue:@"tianyi_navi_pdager_IP v1.0 App" forHTTPHeaderField:@"x-up-agent"];
    
    [manager.requestSerializer setValue:@"18855121624" forHTTPHeaderField:@"Tianyi_navi_pdager_AN"];
    
    [manager.requestSerializer setValue:@"1E84497E-615F-453A-A976-C5CBEA9BB00B" forHTTPHeaderField:@"x-up-gudid"];
    
    [manager.requestSerializer setValue:@"C0E6FF41DC5E2B45DB13E7609C48C137730EF7BDE5EE6B2347C12C9E7CE7225F9AB9F15BCC617A10" forHTTPHeaderField:@"x-up-imsi"];
    [manager.requestSerializer setValue:@"1E84497E-615F-453A-A976-C5CBEA9BB00B" forHTTPHeaderField:@"x-up-macaddr"];
    [manager.requestSerializer setValue:@"1EC98B947B7C14366327EB166C6DF21F" forHTTPHeaderField:@"x-up-mdn"];
    [manager.requestSerializer setValue:@"18855121624" forHTTPHeaderField:@"x-up-mdn"];
    
    NSString *url = [NSString stringWithFormat:@"http:platform.enavi.118114.cn:8081/telecomnavi/BService?id=323"];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"####%@",responseObject);
       NSMutableString * strdata = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"&&&%@",strdata);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

//    if (![self getDesInfo])
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取失败"
//                                                         message:@"获取目的地信息失败，请检查网络链接"
//                                                        delegate:nil
//                                               cancelButtonTitle:@"知道了，谢谢"
//                                               otherButtonTitles:nil];
//        [alert show];
//        
//    }
}

- (BOOL) getDesInfo
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeHomeButtonTitle object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeCompanyButtonTitle object:nil];
//    self.reverseGeocoder = nil;
//    self.reverseGeocoder.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
