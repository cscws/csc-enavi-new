//
//  KCRouteViewController.m
//  eNavi
//
//  Created by csc on 16/3/3.
//  Copyright © 2016年 csc. All rights reserved.
//
#define BtnNomalbackgroundColor          ([UIColor colorWithRed:73.0/255 green:183.0/255 blue:233.0/255 alpha:1])
#define BtnSelectbackgroundColor          ([UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1])
#import "KCRouteViewController.h"
#import "KCSearchViewController.h"
#import "KCSearchResultController.h"
#import "KCRouteDetailController.h"
#import "KCTapViewController.h"
#import "RouteStyleHisModel.h"
#import "RouteStyleHisCell.h"
#import "KCOffenView.h"
@interface KCRouteViewController ()<UITextFieldDelegate,MBReverseGeocodeDelegate,UITableViewDelegate,UITableViewDataSource,offenViewDelegate>
@property (nonatomic, weak) UITextField *pStartField;
@property (nonatomic, weak) UITextField *pMidField;
@property (nonatomic, weak) UITextField *pEndField;
@property (nonatomic, weak) UIImageView *lineImg;
@property (nonatomic, weak) UIButton *changeBtn;
@property (nonatomic, weak) UIButton *JCBtn;
@property (nonatomic, weak) UIButton *GJBtn;
@property (nonatomic, weak) UIButton *BXBtn;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIView   *m_ViewSetting;
@property (nonatomic, weak) KCOffenView   *offenView;
@property (nonatomic, weak) UIButton *distanceBtn;
@property (nonatomic, weak) UIButton *tujingBtn;
@property (nonatomic, weak) UITableView *historytableView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, strong) NSDictionary *poiDict;
//@property (nonatomic, strong) MBReverseGeocoder *reverseGeocoder;
@property (nonatomic, strong) NSMutableArray *hisArray;
@property (nonatomic, assign) MBPoint homePoi;
@property (nonatomic, assign) MBPoint compPoi;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *typeStr;
@end

@implementation KCRouteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringStartValue:) name:@"bringStartValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringEndValue:) name:@"bringEndValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringMidValue:) name:@"bringMidValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHomeButtonTitle:) name:ChangeHomeTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changecompanyButtonTitle:) name:ChangeCompanyTitle object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
        _JCBtn.backgroundColor = BtnNomalbackgroundColor;
        _GJBtn.backgroundColor = BtnNomalbackgroundColor;
        _BXBtn.backgroundColor = BtnNomalbackgroundColor;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    _poiDict = [NSDictionary dictionary];
    [self setNavigationBar];
    [self setSubViews];
//    self.reverseGeocoder = [[MBReverseGeocoder alloc] init];
//    self.reverseGeocoder.mode = MBReverseGeocodeMode_online;
}

- (NSMutableArray *)hisArray
{
    if (_hisArray == nil)
    {
            _hisArray = [NSKeyedUnarchiver unarchiveObjectWithFile:RouteStyleHisFilePath];
    if (_hisArray==nil) {
            _hisArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return _hisArray;
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
    titleLabel.text = @"路线";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
}

- (void)setSubViews
{

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kVCViewcolor;
    self.headerView = headerView;
    
    UIView *m_ViewSetting = [[UIView alloc] init];
   // m_ViewSetting.frame = CGRectMake(iX, iY, iW, iH);
    m_ViewSetting.backgroundColor = [UIColor whiteColor];
    m_ViewSetting.layer.borderColor = kLayerBorderColor;
    m_ViewSetting.layer.borderWidth = 1.0f;
    //m_ViewSetting.layer.cornerRadius = 4.0f;
    _m_ViewSetting = m_ViewSetting;
    [self.headerView addSubview:_m_ViewSetting];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
 //   lineImg.frame = CGRectMake(20, 20, 10, 50);
    UIImage *img = [UIImage imageNamed:@"add_bar"];
    lineImg.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 10, 0) resizingMode:UIImageResizingModeStretch];
    self.lineImg = lineImg;
    [m_ViewSetting addSubview:lineImg];
    
    UIButton *tujingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 //   tujingBtn.frame = CGRectMake(11, 20, 30, 50);
    [tujingBtn setImage:[UIImage imageNamed:@"btn_add_spot_normal"] forState:UIControlStateNormal];
    [tujingBtn setImage:[UIImage imageNamed:@"btn_add_spot_pressing"] forState:UIControlStateHighlighted];
    [tujingBtn addTarget:self action:@selector(tujingdian) forControlEvents:UIControlEventTouchUpInside];
    self.tujingBtn = tujingBtn;
    [m_ViewSetting addSubview:tujingBtn];
    
    
   UITextField *pStartField = [[UITextField alloc] init];
 //   pStartField.frame = CGRectMake(startX, 10,kMainScreenSizeWidth-2*startX, 30);
    pStartField.layer.borderWidth = 1;
    pStartField.layer.borderColor = kLayerBorderColor;
    
//    [_pStartField setTitle:@"设置起点" forState:UIControlStateNormal];
//    [_pStartField setTitleColor:[UIColor colorWithRed:104/255 green:112/255 blue:120/255 alpha:0.6] forState:UIControlStateNormal];
    pStartField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;

    //_pStartField.returnKeyType = UIReturnKeyDone;
    pStartField.font = [UIFont systemFontOfSize: 14.0];
    pStartField.text = @"我的位置";
    pStartField.textColor = kTextFontColor;
    pStartField.delegate = self;
    pStartField.tag = 20;
    self.pStartField = pStartField;
    [m_ViewSetting addSubview:pStartField];
    
    
    UITextField *pMidFeild = [[UITextField alloc] init];
    pMidFeild.frame = _pEndField.frame;
    pMidFeild.layer.borderWidth = 1;
    pMidFeild.layer.borderColor = kLayerBorderColor;
    pMidFeild.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    pMidFeild.font = [UIFont systemFontOfSize: 14.0];
    pMidFeild.placeholder = @"途经点";
    pMidFeild.textColor = kTextFontColor;
    pMidFeild.delegate = self;
    pMidFeild.tag = 22;
    self.pMidField = pMidFeild;
    [m_ViewSetting addSubview:pMidFeild];
    
   UITextField *pEndField = [[UITextField alloc] init];
 //   pEndField.frame = CGRectMake(startX, endY+10,kMainScreenSizeWidth-2*startX, 30);
    pEndField.layer.borderWidth = 1;
    pEndField.layer.borderColor = kLayerBorderColor;
    pEndField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    pEndField.placeholder = @"选择目的地";
    if(_endStr!=nil)
    {
        pEndField.text = _endStr;
    }
    pEndField.delegate = self;
    pEndField.tag = 21;
    pEndField.font = [UIFont systemFontOfSize: 14.0];
    pEndField.textColor = kTextFontColor;
    self.pEndField = pEndField;
    [m_ViewSetting addSubview:_pEndField];

    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 //   changeBtn.frame = CGRectMake(btnX, 0, m_ViewSetting.frame.size.width-width, btnH+10);
    [changeBtn setImage:[UIImage imageNamed:@"btn_alter_normal"] forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"btn_alter_pressing"] forState:UIControlStateHighlighted];
    [changeBtn addTarget:self action:@selector(changePstartAndPend:) forControlEvents:UIControlEventTouchUpInside];
    self.changeBtn = changeBtn;
    [m_ViewSetting addSubview:changeBtn];

   
   UIButton *JCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    JCBtn.frame = CGRectMake(startX, JCBtnY, JCWidth, Height);
    JCBtn.backgroundColor = BtnNomalbackgroundColor;
    self.JCBtn = JCBtn;
    [self setButton:JCBtn withImg:@"btn_drive" selectImg:@"btn_drive" title:@"驾车" action:@selector(JCBtnClicked)];
    
    UIButton *GJBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    GJBtn.frame = CGRectMake(GJBtnX, JCBtnY, JCWidth, Height);
    //_GJBtn.backgroundColor = [UIColor blueColor];
    GJBtn.backgroundColor = BtnNomalbackgroundColor;
    self.GJBtn = GJBtn;
    [self setButton:GJBtn withImg:@"btn_bus" selectImg:@"btn_bus" title:@"公交" action:@selector(GJBtnClicked)];
    
   UIButton *BXBtn = [UIButton buttonWithType:UIButtonTypeCustom];

//    BXBtn.frame = CGRectMake(BXBtnX, JCBtnY, JCWidth, Height);
   // _BXBtn.backgroundColor = [UIColor blueColor];
    BXBtn.backgroundColor = BtnNomalbackgroundColor;
    self.BXBtn = BXBtn;
    [self setButton:BXBtn withImg:@"btn_walk" selectImg:@"btn_walk" title:@"步行" action:@selector(BXBtnClicked)];
    
//    CGFloat padding = 5.0;
//    CGFloat offenUseLabelY = CGRectGetMaxY(m_ViewSetting.frame);
//    UILabel *offenUseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offenUseLabelY+5, 60, 20)];
//    offenUseLabel.text = @"常用地点";
//    offenUseLabel.font = [UIFont systemFontOfSize:12.0];
//    offenUseLabel.textColor = kTextFontColor;
//    [self.headerView addSubview:offenUseLabel];

  //  CGFloat offenViewY = CGRectGetMaxY(offenUseLabel.frame);
    KCOffenView *offenView = [[KCOffenView alloc] init];
  //  offenView.frame = CGRectMake(0, offenViewY, kMainScreenSizeWidth-2*padding, 120);
    offenView.delegate = self;
    offenView.backgroundColor = [UIColor whiteColor];
    [offenView.layer setMasksToBounds:YES];
    [offenView.layer setCornerRadius:2];
    offenView.layer.borderWidth = 0.5;
    offenView.layer.borderColor = kLayerBorderColor;
    self.offenView = offenView;
    [self.headerView addSubview:offenView];
 
    UITableView *historyView = [[UITableView alloc] initWithFrame:CGRectMake(5, 69, kMainScreenSizeWidth-10, kMainScreenSizeHeight-69)];
    self.historytableView = historyView;
    historyView.backgroundColor = kVCViewcolor;
    historyView.tableFooterView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, kMainScreenSizeWidth-10, 290);
    historyView.tableHeaderView = _headerView;
    [historyView.layer setMasksToBounds:YES];
    [historyView.layer setCornerRadius:2];
    historyView.layer.borderWidth = 0.5;
    historyView.layer.borderColor = kLayerBorderColor;
    historyView.delegate = self;
    historyView.dataSource = self;
    historyView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:historyView];
    
    
    [self setsubviewsFrame];
}

- (void)setsubviewsFrame
{
    __weak __typeof(self) weakSelf = self;

    [weakSelf.m_ViewSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(weakSelf.headerView);
        make.right.mas_equalTo(weakSelf.headerView);
        make.bottom.mas_equalTo(weakSelf.JCBtn.mas_bottom).offset(10);
    }];
    
    [weakSelf.lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
        make.left.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(55);
        
    }];
    
    [weakSelf.tujingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.lineImg);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [weakSelf.pStartField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.m_ViewSetting).offset(10);
        make.left.mas_equalTo(weakSelf.lineImg).offset(30);
        make.width.mas_equalTo(weakSelf.view).offset(-120);
        make.height.mas_equalTo(30);
    }];
    
    [weakSelf.pMidField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.pStartField.mas_bottom).offset(10);
        make.left.right.mas_equalTo(weakSelf.pStartField);
        make.height.mas_equalTo(0.1);
    }];
    
    
    [weakSelf.pEndField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.pMidField.mas_bottom).offset(10);
        make.left.right.height.mas_equalTo(weakSelf.pStartField);
    }];
    
    [weakSelf.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tujingBtn);
        make.height.width.mas_equalTo(weakSelf.tujingBtn);
        make.right.mas_equalTo(weakSelf.m_ViewSetting).offset(-20);
    }];
    
    [weakSelf.JCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.pEndField.mas_bottom).offset(10);
        make.left.mas_equalTo(weakSelf.pEndField);
       // make.right.mas_equalTo(weakSelf.GJBtn.mas_left).offset(-10);
        make.width.mas_equalTo(_GJBtn);
        make.height.mas_equalTo(30);
        
    }];
    
    [weakSelf.GJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JCBtn);
        make.left.mas_equalTo(weakSelf.JCBtn.mas_right).offset(10);
      //  make.right.mas_equalTo(weakSelf.BXBtn.mas_left).offset(-10);
        make.width.mas_equalTo(weakSelf.BXBtn);
        make.height.mas_equalTo(weakSelf.JCBtn);
    }];
    
    [weakSelf.BXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.JCBtn);
        make.left.mas_equalTo(weakSelf.GJBtn.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.pEndField);
        make.height.mas_equalTo(weakSelf.JCBtn);
    }];
    
    [weakSelf.offenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.m_ViewSetting.mas_bottom).offset(10);
        make.left.right.mas_equalTo(weakSelf.m_ViewSetting);
        make.height.mas_equalTo(120);
    }];
}

- (void)tujingdian
{
    _tujingBtn.selected = !_tujingBtn.selected;
    __weak __typeof(self) weakSelf = self;
    if(_tujingBtn.selected)
    {
        
        [_tujingBtn setImage:[UIImage imageNamed:@"btn_reduce_spot_normal"] forState:UIControlStateNormal];
        [_tujingBtn setImage:[UIImage imageNamed:@"btn_reduce_spot_pressing"] forState:UIControlStateHighlighted];
        
        _headerView.frame = CGRectMake(0, 0, kMainScreenSizeWidth-10, 310);
        _historytableView.tableHeaderView = _headerView;
        [weakSelf.pMidField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.pStartField.mas_bottom).offset(10);
            make.left.right.height.mas_equalTo(weakSelf.pStartField);
        }];
        
        
        [weakSelf.lineImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
            make.left.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(85);
            
        }];

    }
    else
    {
        
        [_tujingBtn setImage:[UIImage imageNamed:@"btn_add_spot_normal"] forState:UIControlStateNormal];
        [_tujingBtn setImage:[UIImage imageNamed:@"btn_add_spot_pressing"] forState:UIControlStateHighlighted];

          _headerView.frame = CGRectMake(0, 0, kMainScreenSizeWidth-10, 290);
          _historytableView.tableHeaderView = _headerView;
            [weakSelf.pMidField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.pStartField.mas_bottom).offset(10);
                make.left.right.height.mas_equalTo(0.1);
            }];
        
        [weakSelf.lineImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
            make.left.mas_equalTo(weakSelf.m_ViewSetting).offset(20);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(55);
            
        }];

    }
}

- (void)setButton:(UIButton *)btn withImg:(NSString *)imgNM selectImg:(NSString *)sImgNM title:(NSString *)title action:(SEL)action
{
    [btn setImage:[UIImage imageNamed:imgNM] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:sImgNM] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //btn.layer.borderWidth = 0.5;
    [btn.titleLabel setFont:font(14.0)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    btn.adjustsImageWhenHighlighted = NO;
    [_m_ViewSetting addSubview:btn];
}



- (void)changePstartAndPend:(id)sender
{
    
    
    if(_pEndField.text.length != 0)
    {
        CGRect frame;
        frame = _pStartField.frame;
        _pStartField.frame = _pEndField.frame;
        _pEndField.frame = frame;
        
        MBPoint poi = self.startPoi;
        self.startPoi = self.endPoi;
        self.endPoi = poi;
    }
    else
    {
    [SVProgressHUD showInfoWithStatus:@"请设置目的地"];
    }    
}

//垃圾代码
- (void)JCBtnClicked
{
    [self archiveHistoryWithBtnType:@"JC"];
    [self checkPendFieldTextlengthAndBringButtonType:buttonType_JC buntton:_JCBtn];
    
}

- (void)GJBtnClicked
{
    [self archiveHistoryWithBtnType:@"GJ"];
    [self checkPendFieldTextlengthAndBringButtonType:buttonType_GJ buntton:_GJBtn];
    
}

- (void)BXBtnClicked
{
    [self archiveHistoryWithBtnType:@"BX"];
    [self checkPendFieldTextlengthAndBringButtonType:buttonType_BX buntton:_BXBtn];
}

- (void)archiveHistoryWithBtnType:(NSString *)btnType
{
    if(_pStartField.text.length>0 && _pEndField.text.length>0)
    {
    RouteStyleHisModel *model = [[RouteStyleHisModel alloc] init];
    model.startName = _pStartField.text;
    model.endName = _pEndField.text;
    model.midName = _pMidField.text;
    model.btnType = btnType;
        
    model.sX = _startPoi.x;
    model.sY = _startPoi.y;
    
    model.mX = _midPoi.x;
    model.mY = _midPoi.y;
        
    model.eX = _endPoi.x;
    model.eY = _endPoi.y;
        
    [self.hisArray insertObject:model atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.hisArray toFile:RouteStyleHisFilePath];
    }
}

- (void)checkPendFieldTextlengthAndBringButtonType:(buttonType)btnType buntton:(UIButton *)btn
{
    if (btn != _selectBtn)
    {
        _selectBtn.selected = NO;
        _selectBtn.backgroundColor = BtnNomalbackgroundColor;
        _selectBtn = btn;
    }
    _selectBtn.selected = YES;
    _selectBtn.backgroundColor = BtnSelectbackgroundColor;
    
    if (_pEndField.text.length != 0)
    {
        KCRouteDetailController *routeDe = [[KCRouteDetailController alloc] init];
        routeDe.startPoi = _startPoi;
        routeDe.endPoi = _endPoi;
        routeDe.midPoi = _midPoi;
        routeDe.btnType = btnType;
        routeDe.starStr = _pStartField.text;
        routeDe.endStr = _pEndField.text;
        routeDe.node = self.node;
        routeDe.parentObjId = self.parentObjId;
        [self.navigationController pushViewController:routeDe animated:YES];
        
    }else
    {
        [SVProgressHUD showInfoWithStatus:@"请设置目的地"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    KCSearchViewController *search = [[KCSearchViewController alloc] init];
    search.VCclass = [self class];
    search.startPoint = self.startPoi;
    search.cityNode = self.node;
    if (textField.tag==20)
    {
        search.index = textField.tag;
        [_pStartField endEditing:YES];
    }
    else if (textField.tag==21)
    {
        search.index = textField.tag;
        [_pEndField endEditing:YES];
    }
    else
    {
        search.index = textField.tag;
        [_pMidField endEditing:YES];
    }
    
    [self.navigationController pushViewController:search animated:YES];
}

//接受通知
- (void)bringStartValue:(NSNotification *)noti
{
    NSDictionary *dict = [noti object];
    _pStartField.text = dict[@"name"];
    NSValue *pointValue = dict[@"poi"];
    CGPoint point = [pointValue CGPointValue];
    _startPoi.x = point.x;
    _startPoi.y = point.y;
}

- (void)bringMidValue:(NSNotification *)noti
{
    NSDictionary *dict = [noti object];
    _pMidField.text = dict[@"name"];
    NSValue *pointValue = dict[@"poi"];
    CGPoint point = [pointValue CGPointValue];
    _midPoi.x = point.x;
    _midPoi.y = point.y;
}


- (void)bringEndValue:(NSNotification *)noti
{
    NSDictionary *dict = [noti object];
    _pEndField.text = dict[@"name"];
    NSValue *pointValue = dict[@"poi"];
    CGPoint point = [pointValue CGPointValue];
    _endPoi.x = point.x;
    _endPoi.y = point.y;
}


- (void)changeHomeButtonTitle:(NSNotification *)noti
{
 //   self.reverseGeocoder.delegate = self;
    _poiDict = noti.object;
    CGPoint poi = [_poiDict[@"poi"] CGPointValue];
    _homePoi.x = poi.x;
    _homePoi.y = poi.y;
 //   [self.reverseGeocoder reverseByPoint:&_homePoi];
    _typeStr = _poiDict[@"name"];
    [_offenView.homeNameBtn setTitle:_typeStr forState:UIControlStateNormal];
    [User setObject:_typeStr forKey:@"homePoiName"];
    [User setInteger:_homePoi.x forKey:@"homePoix"];
    [User setInteger:_homePoi.y forKey:@"homePoiy"];
}

- (void)changecompanyButtonTitle:(NSNotification *)noti
{
   // self.reverseGeocoder.delegate = self;
    _poiDict = noti.object;
    CGPoint poi = [_poiDict[@"poi"] CGPointValue];
    _compPoi.x = poi.x;
    _compPoi.y = poi.y;
  //  [self.reverseGeocoder reverseByPoint:&_compPoi];
    _typeStr = _poiDict[@"name"];
   [_offenView.companyNameBtn setTitle:_typeStr forState:UIControlStateNormal];
    [User setObject:_typeStr forKey:@"companyPoiName"];
    [User setInteger:_compPoi.x forKey:@"companyPoix"];
    [User setInteger:_compPoi.y forKey:@"companyPoiy"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    RouteStyleHisCell *cell = [RouteStyleHisCell cellWithTableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.hisArray[indexPath.row];
    [cell buttonOnCellClicked:^(RouteStyleHisModel *model) {
        _pStartField.text = model.startName;
        _pEndField.text = model.endName;
        NSInteger sx = model.sX;
        NSInteger sy = model.sY;
        _startPoi.x = (int)sx;
        _startPoi.y = (int)sy;
      if(model.midName.length>0)
      {
        _pMidField.text = model.midName;
        NSInteger mx = model.mX;
        NSInteger my = model.mY;
        _midPoi.x = (int)mx;
        _midPoi.y = (int)my;
        [self tujingdian];
      }
        NSInteger ex = model.eX;
        NSInteger ey = model.eY;
        _endPoi.x = (int)ex;
        _endPoi.y = (int)ey;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RouteStyleHisModel *model = self.hisArray[indexPath.row];
    KCRouteDetailController *routeDe = [[KCRouteDetailController alloc] init];
    NSInteger sx = model.sX;
    NSInteger sy = model.sY;
    _startPoi.x = (int)sx;
    _startPoi.y = (int)sy;
    routeDe.starStr = model.startName;
    
    NSInteger mx = model.mX;
    NSInteger my = model.mY;
    _midPoi.x = (int)mx;
    _midPoi.y = (int)my;
    routeDe.midStr = model.midName;
    
    NSInteger ex = model.eX;
    NSInteger ey = model.eY;
    _endPoi.x = (int)ex;
    _endPoi.y = (int)ey;
    routeDe.endStr = model.endName;
    
    NSLog(@"^^^^^^^^^%d",_midPoi.x);
    
    routeDe.startPoi = _startPoi;
    routeDe.endPoi = _endPoi;
    routeDe.midPoi = _midPoi;
    
    routeDe.node = self.node;
    routeDe.parentObjId = self.parentObjId;
    if([model.btnType isEqualToString:@"JC"])
    {
    routeDe.btnType = buttonType_JC;
    }
    else if([model.btnType isEqualToString:@"GJ"])
    {
    routeDe.btnType = buttonType_GJ;
    }
    else
    {
    routeDe.btnType = buttonType_BX;
    }
    [self.navigationController pushViewController:routeDe animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.hisArray removeObjectAtIndex:indexPath.row];
        
        [NSKeyedArchiver archiveRootObject:self.hisArray toFile:RouteStyleHisFilePath];
        [self.historytableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)sendBtnOneOfenView:(UIButton *)btn
{
    if(btn.tag==14 || btn.tag==17)
    {
        
        if(btn.tag==14)
        {
       _pEndField.text = [_offenView.homeNameBtn currentTitle];
            NSInteger x = [User integerForKey:@"homePoix"];
            NSInteger y = [User integerForKey:@"homePoiy"];
            _endPoi.x = (int)x;
            _endPoi.y = (int)y;
        }
        else if (btn.tag==17)
        {
      _pEndField.text = [_offenView.companyNameBtn currentTitle];
            NSInteger x = [User integerForKey:@"companyPoix"];
            NSInteger y = [User integerForKey:@"companyPoiy"];
            _endPoi.x = (int)x;
            _endPoi.y = (int)y;
            
        }
    }
    else
    {
        if (btn.currentTitle == nil)
        {
            KCSearchViewController *search = [[KCSearchViewController alloc] init];
            search.VCclass = [self class];
            search.startPoint = self.startPoi;
            search.cityNode = self.node;
            search.index = btn.tag;
            [self.navigationController pushViewController:search animated:YES];
            
        }
        else
        {
            KCRouteDetailController *routeDe = [[KCRouteDetailController alloc] init];
            if(btn.tag==15)
            {
                NSInteger x = [User integerForKey:@"homePoix"];
                NSInteger y = [User integerForKey:@"homePoiy"];
                _endPoi.x = (int)x;
                _endPoi.y = (int)y;
                
          routeDe.endStr = [_offenView.homeNameBtn currentTitle];
            }
            else if (btn.tag == 16)
            {
                NSInteger x = [User integerForKey:@"companyPoix"];
                NSInteger y = [User integerForKey:@"companyPoiy"];
                _endPoi.x = (int)x;
                _endPoi.y = (int)y;
          routeDe.endStr = [_offenView.companyNameBtn currentTitle];
            }
            routeDe.startPoi = _startPoi;
            routeDe.endPoi = _endPoi;
            routeDe.btnType = buttonType_JC;
            routeDe.starStr = _pStartField.text;
            routeDe.node = self.node;
            routeDe.parentObjId = self.parentObjId;
//        NSLog(@"###%d,%@,%@",_endPoi.x,_pStartField.text,[_companyNameBtn currentTitle]);
            [self.navigationController pushViewController:routeDe animated:YES];
            
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringStartValue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringEndValue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringMidValue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCompanyTitle object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeHomeTitle object:nil];
    [[ UIApplication sharedApplication ] setIdleTimerDisabled:NO];
}

- (void)back
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
