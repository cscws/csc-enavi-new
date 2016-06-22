//
//  KCMoreViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/7.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCMoreViewController.h"
#import "moreTableViewCell.h"
#import "KCItemModel.h"
#import "KCGroupModel.h"
#import "KCitemArrow.h"
#import "KCitemSwitch.h"
#import "KCNaviViewController.h"
#import "KCViewController.h"
#import "MBDataManagerViewController.h"
#import "KCPersonalViewController.h"
#import "KCWebViewControler.h"
#import "KCSetViewController.h"
@interface KCMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *moreTableView;
@property (nonatomic, strong)NSMutableArray *allGroup;
@property (nonatomic, weak) UIButton *numberBtn;
@end

@implementation KCMoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    NSString *phoneNumber = [User objectForKey:@"Tianyi_navi_pdager_IP_Mdn_Key"];
    if(phoneNumber.length==0)
    {
        [_numberBtn setTitle:@"绑定号码"forState:UIControlStateNormal];
    }
    else
    {
        [_numberBtn setTitle:[NSString stringWithFormat:@"天翼账号:%@",phoneNumber] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self creatTableView];
    [self setNavigationBar];
}

- (NSMutableArray *)allGroup
{
    if(_allGroup == nil)
    {
        _allGroup = [NSMutableArray arrayWithCapacity:0];
        
        KCGroupModel *groupOne = [[KCGroupModel alloc] init];
        //1组
        KCitemArrow *XCModel = [KCitemArrow modelWithIcon:@"car_coupon" title:@"去洗车"];
        XCModel.desVC = @"QXC";
        groupOne.itemArr = @[XCModel];
        
        //2组
        KCitemArrow *DGModel = [KCitemArrow modelWithIcon:@"order" title:@"订购和礼券"];
        //  DGModel.desVC = @"more";
        KCitemArrow *SCModel = [KCitemArrow modelWithIcon:@"fav" title:@"收藏夹"];
        SCModel.desVC = @"collection";
        KCitemArrow *SZModel = [KCitemArrow modelWithIcon:@"set" title:@"设置"];
        SZModel.desVC = @"SZ";
        KCGroupModel *groupTwo = [[KCGroupModel alloc] init];
        
        groupTwo.itemArr = @[DGModel,SCModel,SZModel];
        
        //3组
        KCitemArrow *GGModel = [KCitemArrow modelWithIcon:@"mybus" title:@"公共交通"];
        KCitemArrow *LXModel = [KCitemArrow modelWithIcon:@"offline_data" title:@"离线数据"];
        LXModel.desVC = @"LX";
        KCitemArrow *WZModel = [KCitemArrow modelWithIcon:@"break_rule" title:@"违章查询"];
        KCitemArrow *XXModel = [KCitemArrow modelWithIcon:@"pass_forbid" title:@"限行提醒"];
        XXModel.desVC = @"XX";
        KCGroupModel *groupThree = [[KCGroupModel alloc] init];
        
        groupThree.itemArr = @[GGModel,LXModel,WZModel,XXModel];
        // groupTwo.headerStr =@"其他设置";
        
        //        KCitemSwitch *YYModel = [KCitemSwitch modelWithIcon:@"fav" title:@"远游"];
        //        KCitemSwitch *QZNModel = [KCitemSwitch modelWithIcon:@"fav" title:@"亲在哪"];
        //        KCGroupModel *groupFour = [[KCGroupModel alloc] init];
        //        groupFour.itemArr = @[YYModel,QZNModel];
        
        [_allGroup addObject:groupOne];
        [_allGroup addObject:groupTwo];
        [_allGroup addObject:groupThree];
        //       [_allGroup addObject:groupFour];
        
    }
    return _allGroup;
}

- (void)setNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kMainScreenSizeWidth, 150)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
    imgView.image = [UIImage imageNamed:@"bkg"];
    [view addSubview:imgView];
    [self.view addSubview:view];
    
    
    CGFloat btnY = 24.0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //CGFloat btnY = (CGRectGetMaxY(view.frame)-30)/2;
    backBtn.frame = CGRectMake(0, btnY, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake((view.frame.size.width-55)/2, btnY, 55, 55);
    [headerBtn setImage:[UIImage imageNamed:@"btn_avater"] forState:UIControlStateNormal];
    [headerBtn addTarget:self action:@selector(jumpToLogin:) forControlEvents:UIControlEventTouchUpInside];
    //[backBtn addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:headerBtn];
    
    CGFloat numBtnY = CGRectGetMaxY(headerBtn.frame);
    UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numberBtn.frame = CGRectMake((view.frame.size.width-200)/2, numBtnY, 200, 30);
    [numberBtn setImage:[UIImage imageNamed:@"tianyi_logo"] forState:UIControlStateNormal];
    numberBtn.userInteractionEnabled = NO;
    numberBtn.titleLabel.font = font(14.0);
    self.numberBtn = numberBtn;
    [view addSubview:numberBtn];
    
}

- (void)creatTableView
{
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kMainScreenSizeWidth, kMainScreenSizeHeight-150) style:UITableViewStyleGrouped];
    // _moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _moreTableView.layer.borderWidth = 0.5;
    //    _moreTableView.layer.borderColor = kLayerBorderColor;
    _moreTableView.showsVerticalScrollIndicator = NO;
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    [self.view addSubview:_moreTableView];
}

- (void)jumpToLogin:(UIButton *)btn
{
    NSString *phoneNumber = [User objectForKey:@"Tianyi_navi_pdager_IP_Mdn_Key"];
    if(phoneNumber==nil)
    {
        KCPersonalViewController *person = [[KCPersonalViewController alloc] init];
        [self.navigationController pushViewController:person animated:YES];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    KCGroupModel *group = self.allGroup[section];
    return group.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    moreTableViewCell *cell = [moreTableViewCell cellWithTableView:tableView];
    
    KCGroupModel *group = self.allGroup[indexPath.section];
    cell.model = group.itemArr[indexPath.row];
    return cell;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    KCGroupModel *group = self.allGroup[section];
//    return group.headerStr;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    KCGroupModel *group = self.allGroup[indexPath.section];
    KCItemModel *item = group.itemArr[indexPath.row];
    
    if ([item isKindOfClass:[KCitemArrow class]])
    {
        KCitemArrow *dest = (KCitemArrow *)item;
        if ([dest.desVC isEqualToString:@"collection"])
        {
            UIViewController *nav = [storyB instantiateViewControllerWithIdentifier:dest.desVC];
            // [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:nav animated:YES];
        }
        else if ([dest.desVC isEqualToString:@"LX"])
        {
            MBDataManagerViewController *nav = [[MBDataManagerViewController alloc] init];
            [self.navigationController pushViewController:nav animated:YES];
        }
        else if ([dest.desVC isEqualToString:@"XX"])
        {
            KCWebViewControler *web = [[KCWebViewControler alloc] init];
#pragma 不同的code不同的城市
            web.controllerType = @"限行";
            web.code = 3100;
            [self.navigationController pushViewController:web animated:YES];
        }
        else if ([dest.desVC isEqualToString:@"QXC"])
        {
            KCWebViewControler *info = [[KCWebViewControler alloc] init];
            info.controllerType = @"车小秘";
            [self.navigationController pushViewController:info animated:YES];
        }
        else if([dest.desVC isEqualToString:@"SZ"])
        {
            KCSetViewController *seting = [[KCSetViewController alloc] init];
            [self.navigationController pushViewController:seting animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


@end
