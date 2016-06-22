//
//  KCDriveDetailViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/1.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCDriveDetailViewController.h"
#import "KCNaviViewController.h"
@interface KCDriveDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *endbtn;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *routeDistanceAndTime;

@property (weak, nonatomic) IBOutlet UITableView *routeTableView;
@property (nonatomic, strong) NSMutableArray *routeArr;
@property (nonatomic, strong) MBRouteDescriptionItem *routeDescriptionItem;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@end

@implementation KCDriveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    [self creatTableView];
    
    self.routeDistanceAndTime.text = [NSString stringWithFormat:@"%@--%@",_distanceStr,_timeStr];
    [self.endbtn setTitle:_endStr forState:UIControlStateNormal];
    [self.startBtn setTitle:_startStr forState:UIControlStateNormal];
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
    titleLabel.text = @"路线详情";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
}


- (NSMutableArray *)routeArr
{
    if (_routeArr==nil)
    {
        _routeArr = [NSMutableArray arrayWithCapacity:0];
        // 判断当前路线是否为空
        if ([self.routeBase getRouteBase] != NULL) {
            // 返回路线详情中路线说明的个数(区别于路线个数)
            NSInteger num = [self.routeBase getDescriptionNumber];
            for (int i = 0; i < num; i++) {
                
                MBRouteDescriptionItem *item = [self.routeBase getDescriptionItem:i curDistance:0x7fffffff];
                [self.routeArr addObject:item];
    }
    }
    }
        return _routeArr;
}

- (void)creatTableView
{
    _headerView.layer.borderWidth = 0.5;
    _headerView.layer.borderColor = kLayerBorderColor;
    _buttonView.layer.borderWidth = 0.5;
    _buttonView.layer.borderColor = kLayerBorderColor;
    
    _routeTableView.showsVerticalScrollIndicator = NO;
    _routeTableView.layer.borderWidth = 0.5;
    _routeTableView.layer.borderColor = kLayerBorderColor;
    _routeTableView.delegate = self;
    _routeTableView.dataSource = self;
  //  _routeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"history";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.textColor = kTextFontColor;
    MBRouteDescriptionItem *item = self.routeArr[indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"turn_icons%d",item.iconId]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startNavi:(UIButton *)sender {
    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = _startPoint;
    navi.endPoint = _endPoint;
    navi.midPoint = _midPoint;
    // 选择导航模式的 index
    navi.index = 0;
    [self.navigationController pushViewController:navi animated:YES];
}

- (IBAction)startSimNavi:(DetailButton *)sender {
    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = _startPoint;
    navi.endPoint = _endPoint;
    navi.midPoint = _midPoint;
    navi.index = 100;
    [self.navigationController pushViewController:navi animated:YES];
}

#pragma 获取路线reloadtableView
- (IBAction)checkReturnBtn:(DetailButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        [self.endbtn setTitle:_startStr forState:UIControlStateNormal];
        [self.startBtn setTitle:_endStr forState:UIControlStateNormal];
    }
    else
    {
        [self.endbtn setTitle:_endStr forState:UIControlStateNormal];
        [self.startBtn setTitle:_startStr forState:UIControlStateNormal];
    }
}

- (IBAction)shareBtn:(DetailButton *)sender {
    
}
@end
