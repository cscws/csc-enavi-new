//
//  KCCityListViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCCityListViewController.h"
#import <iNaviCore/MBWorldManager.h>
#import "HeaderView.h"
#import "ProvinceModel.h"
#import "KCViewController.h"
#import "KCSecondSearchViewController.h"
#import "KCNaviDetailViewController.h"
#import "AppTool.h"

@interface KCCityListViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderViewDelegate>
/**
 *  用来存放省的数组
 */
@property (nonatomic, strong) NSMutableArray *provinceArray;
/**
 *  用来存放省的模型数组
 */
@property (nonatomic, strong) NSMutableArray *provinceModelArray;
/**
 *  用来存放市的数组
 */
@property (nonatomic, strong) NSMutableArray *cityArray;
/**
 *  用来存放省跟市的字典
 */
@property (nonatomic, strong) NSMutableDictionary *dic;
/**
 *  县
 */
@property (nonatomic, strong) NSMutableArray *towns;
/**
 *  用来存放市和县
 */
@property (nonatomic, strong) NSMutableDictionary *CTdic;
/**
 *  城市管理者
 */
@property (nonatomic, strong) MBWorldManager *worldManager;

@property (nonatomic, strong) UITableView *tabelView;
//@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, copy) NSString *cityName;
@end

@implementation KCCityListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenSizeWidth, kMainScreenSizeHeight-64) style:UITableViewStylePlain];
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tabelView];
    
    self.provinceArray = [NSMutableArray arrayWithCapacity:0];
    self.provinceModelArray = [NSMutableArray arrayWithCapacity:0];
    self.cityArray = [NSMutableArray arrayWithCapacity:0];
    self.dic = [[NSMutableDictionary alloc] init];
    self.towns = [NSMutableArray arrayWithCapacity:0];
    self.CTdic = [[NSMutableDictionary alloc] init];
    
    // 创建城市管理者
    self.worldManager = [MBWorldManager sharedInstance];
    [self getCitys:[self.worldManager getRoot] worldManager:self.worldManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar
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
    titleLabel.text = @"城市列表";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}


- (void)getCitys:(MBWmrObjId)objId worldManager:(MBWorldManager *)worldManager
{
    // 从全国结点获取第一个子节点(北京)
    MBWmrObjId ProvinceObj = [worldManager getFirstChildId:objId];
    MBWmrNode *ProvinceNode = [worldManager getNodeById:ProvinceObj];
    ProvinceModel *podel = [[ProvinceModel alloc] init];
    // 将第一个(北京)结点存到可变数组中去
#pragma 帝都存在数组第0个
    podel.Pname = ProvinceNode.chsName;
    [self.provinceModelArray insertObject:podel atIndex:0];
    [self.provinceArray addObject:ProvinceNode];
    
    // 获取全国的省,直辖市,行政区(33个)
    NSInteger provinceCount = [worldManager getChildrenNumber:objId];
    for (NSInteger i = 1; i < provinceCount; i++) {
        // 依次获取当前数组中的省,直辖市结点
        MBWmrNode *ProvinceNode = self.provinceArray[i - 1];
        // 依次获取北京市,上海市,天津市,山东省等兄弟结点
        MBWmrObjId provinceObj = [worldManager getNextSiblingId:ProvinceNode.nodeId];
        MBWmrNode *node = [worldManager getNodeById:provinceObj];
        ProvinceModel *pModel = [[ProvinceModel alloc] init];
        pModel.Pname = node.chsName;
        [self.provinceModelArray addObject:pModel];
        [self.provinceArray addObject:node];
    }
    
    // 遍历一级节点,得到二级节点:市,区
    for (NSInteger i = 0; i < self.provinceArray.count; i ++) {
        MBWmrNode *city = [self.provinceArray objectAtIndex:i];
        NSInteger count = [worldManager getChildrenNumber:city.nodeId];
        NSArray *array = [worldManager getChildNodes:city.nodeId];
        NSString *name = city.chsName;
        [self.dic setValue:array forKey:name];
        
        // 把一级节点下的市区存到cityArray数组
        for (NSInteger j = 0; j < count; j++) {
            MBWmrNode *objNode = [array objectAtIndex:j];
            [self.cityArray addObject:objNode];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.provinceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MBWmrNode *node = self.provinceArray[section];
    NSArray *arr = [self.worldManager getChildNodes:node.nodeId];
    ProvinceModel *pModel = self.provinceModelArray[section];
    if (pModel.Open)
    {
    
    return arr.count;
    }
    else
    {
    return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       // cell.textLabel.text = @"浦东区";
    }
    MBWmrNode *Pnode = self.provinceArray[indexPath.section];
    NSArray *arr = [self.worldManager getChildNodes:Pnode.nodeId];
    MBWmrNode *Cnode = arr[indexPath.row];

    [AppTool sentPName:Pnode.chsName CName:Cnode.chsName success:^(NSString *str) {
        cell.textLabel.text = str;
    }];
  
    cell.textLabel.textColor = kTextFontColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#pragma 这里可以重用；没解决好
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, 40)];
    headerView.delegate = self;
    headerView.pModel = _provinceModelArray[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBWmrNode *PNode = self.provinceArray[indexPath.section];
    NSArray *arr = [self.worldManager getChildNodes:PNode.nodeId];
    MBWmrNode *Cnode = arr[indexPath.row];

    [AppTool sentPName:PNode.chsName CName:Cnode.chsName success:^(NSString *str) {
        _cityName = str;
    }];
    
    if (self.VCClass == [KCViewController class])
    {
        if ([self.delegate respondsToSelector:@selector(bringCityNameToKCViewVCWithNode:cityName:)])
        {
            
            [self.delegate bringCityNameToKCViewVCWithNode:Cnode cityName:_cityName];
        }
    }else if (self.VCClass == [KCSecondSearchViewController class])
    {
        if ([self.delegate respondsToSelector:@selector(bringCityNameToKCSencondSearchViewVCWithNode:cityName:)])
        {
            [self.delegate bringCityNameToKCSencondSearchViewVCWithNode:Cnode cityName:_cityName];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(bringCityNameToKCNaviDetailWithNode:cityName:)])
        {
            [self.delegate bringCityNameToKCNaviDetailWithNode:Cnode cityName:_cityName];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerViewbtnDidClicked:(HeaderView *)header
{
    [self.tabelView reloadData];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
