//
//  KCSetPopView.m
//  eNavi
//
//  Created by zuotoujing on 16/6/15.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSetPopView.h"
#import "KCSetGroupModel.h"
#import "KCSetButtonModel.h"
#import "KCSetArrowItemModel.h"
#import "KCSetTitleArrowModel.h"
#import "KCSetTableViewCell.h"
#import "KCSetFirstSectionModel.h"
#import "KCSetFirstTableViewCell.h"
@interface KCSetPopView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *allGroup;
@property (nonatomic, strong) UITableView *setTableView;
@end
@implementation KCSetPopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    [self addSubview:self.setTableView];
    }

    return self;
}

- (UITableView *)setTableView
{
if(_setTableView==nil)
{
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenSizeWidth, kMainScreenSizeHeight-64) style:UITableViewStyleGrouped];
    _setTableView.showsVerticalScrollIndicator = NO;
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
   // automaticallyAdjustsScrollViewInsets=NO
}
    return _setTableView;
}

- (NSMutableArray *)allGroup
{
    if(_allGroup == nil)
    {
        _allGroup = [NSMutableArray arrayWithCapacity:0];
        
        //1组
        KCSetGroupModel *groupOne = [[KCSetGroupModel alloc] init];
        KCSetFirstSectionModel *model = [KCSetFirstSectionModel modelWithTitle:@"路线" index:0];
        groupOne.itemArr = @[model];
        
        //2组
        KCSetGroupModel *groupTwo = [[KCSetGroupModel alloc] init];
        KCSetButtonModel *SJModel = [KCSetButtonModel modelWithTitle:@"地图视角(2D/3D)" index:0];
        KCSetButtonModel *CTModel = [KCSetButtonModel modelWithTitle:@"车头向上" index:1];
        KCSetButtonModel *LKModel = [KCSetButtonModel modelWithTitle:@"路况显示" index:2];
        KCSetButtonModel *RYModel = [KCSetButtonModel modelWithTitle:@"地图日夜模式" index:3];
        KCSetButtonModel *BBModel = [KCSetButtonModel modelWithTitle:@"播报模式" index:4];
        KCSetTitleArrowModel *DHModel = [KCSetTitleArrowModel modelWithTitle:@"导航语音" index:5];
        groupTwo.itemArr = @[SJModel,CTModel,LKModel,RYModel,BBModel,DHModel];
        
        //3组
        KCSetGroupModel *groupThree = [[KCSetGroupModel alloc] init];
        KCSetArrowItemModel *HCModel = [KCSetArrowItemModel modelWithTitle:@"管理缓存" index:0];
        KCSetArrowItemModel *GYModel = [KCSetArrowItemModel modelWithTitle:@"关于" index:1];
        groupThree.itemArr = @[HCModel,GYModel];
        
        [_allGroup addObject:groupOne];
        [_allGroup addObject:groupTwo];
        [_allGroup addObject:groupThree];
        
    }
    return _allGroup;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%lu",(unsigned long)self.allGroup.count);
    return self.allGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    KCSetGroupModel *group = self.allGroup[section];
    NSLog(@"%lu",(unsigned long)group.itemArr.count);
    return group.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tcell;
    if(indexPath.section==0)
    {
        KCSetFirstTableViewCell *cell = [KCSetFirstTableViewCell cellWithTableView:tableView];
        KCSetGroupModel *group = self.allGroup[indexPath.section];
        cell.model = group.itemArr[indexPath.row];
        tcell = cell;
    }
    else
    {
       KCSetTableViewCell *cell = [KCSetTableViewCell cellWithTableView:tableView];
        KCSetGroupModel *group = self.allGroup[indexPath.section];
        cell.model = group.itemArr[indexPath.row];
        tcell = cell;
    }
    [tcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return tcell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"#####%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h ;
    if(indexPath.section==0)
    {
        h=90.0;
    }
    else
    {
        h=40.0;
    }
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


@end
