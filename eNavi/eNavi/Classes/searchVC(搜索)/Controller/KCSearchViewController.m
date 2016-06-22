//
//  KCSearchViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSearchViewController.h"
#import "KCDetailResultController.h"
#import "searchTableViewCell.h"
#import "JZSearchBar.h"
#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"
#import "HistoryTableViewCell.h"
#import "historyModel.h"
@interface KCSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MBPoiQueryDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *resultList;
@property (nonatomic, strong) DetailFrameModel *detailFrameModel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, weak) JZSearchBar *search;
@property (nonatomic, weak) UIButton *clikMapBtn;
@property (nonatomic, weak) UIButton *shouCBtn;
@property (nonatomic, weak) UITableView *historyTableView;
@property (nonatomic, weak)UIButton *deleteBtn;

@property (nonatomic, assign) CGFloat tableViewH;
@property (nonatomic, copy) NSString *historyStr;
@end

@implementation KCSearchViewController

//- (NSMutableArray *)resultList
//{
//if (_resultList==nil)
//{
//    _resultList = [NSMutableArray arrayWithCapacity:0];
//}
//    return _resultList;
//}

- (UIImageView *)imageV
{
    if (_imageV == nil)
    {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detail"]];
    }
    
    return _imageV;
}

- (NSMutableArray *)historyArray
{
    if (_historyArray == nil) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:HistoryFilePath];
        if (_historyArray == nil) {
            _historyArray = [NSMutableArray array];
        }
    }
    
    return _historyArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
     if(_historyTableView != nil)
     {
         NSLog(@"_historyTableView刷新");
         [_historyTableView reloadData];
     }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_search becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    // 初始化 poi 搜索类
    self.poiQuery = [MBPoiQuery sharedInstance];
    MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
    params.mode = MBPoiQueryMode_online;
    self.poiQuery.params = params;
    
    [self setNavigationBar];

    NSLog(@"*****%d",_startPoint.x);
    
   UIButton *clikMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clikMapBtn setTitle:@"地图点选" forState:UIControlStateNormal];
    [clikMapBtn setImage:[UIImage imageNamed:@"btn_circum_map_click"] forState:UIControlStateNormal];
    [clikMapBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    clikMapBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clikMapBtn];
    
   UIButton *shouCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shouCBtn setImage:[UIImage imageNamed:@"btn_circum_collection"] forState:UIControlStateNormal];
    [shouCBtn setTitle:@"收藏夹" forState:UIControlStateNormal];
    [shouCBtn setTitleColor:kTextFontColor forState:UIControlStateNormal];
    shouCBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shouCBtn];

    clikMapBtn.frame = CGRectMake(5, 69, (kMainScreenSizeWidth-5)/2, 50);
    CGFloat shoucBtnX = CGRectGetWidth(clikMapBtn.frame);
    self.clikMapBtn = clikMapBtn;
    shouCBtn.frame = CGRectMake(shoucBtnX, 69, (kMainScreenSizeWidth-5)/2, 50);
    self.shouCBtn = shouCBtn;

    [self creatTableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn = btn;
    btn.frame = CGRectMake(5, kMainScreenSizeHeight-55, kMainScreenSizeWidth-10, 50);
    btn.backgroundColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    [btn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchDown];
        [btn setTitle:@"清除记录" forState:UIControlStateNormal];
   // [btn setImage:[UIImage imageNamed:@"btn_delete_normal"] forState:UIControlStateNormal];
    [self.view addSubview:_deleteBtn];
}

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
    [rightBtn addTarget:self action:@selector(searchRodeResultWithStr:isCellClicked:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:rightBtn];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    //[_search resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    //[_search resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
NSLog(@"textFieldDidBeginEditing");
}

- (void)searchRodeResultWithStr:(NSString *)str isCellClicked:(BOOL)isCellClicked
{

    [self.view endEditing:YES];
    self.poiQuery.delegate = self;
    self.point = self.cityNode.pos;
    [self.poiQuery setWmrId:_cityNode.nodeId];
    if(isCellClicked==YES)
    {
    [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
    [self.poiQuery queryByKeyword:str center:self.point];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"搜索.." maskType:SVProgressHUDMaskTypeBlack];
        if (self.search.text.length > 0) {
            [self.poiQuery queryByKeyword:self.search.text center:self.point];
            
            if (![self.search.text isEqualToString:_historyStr])
            {
                historyModel *model = [historyModel modelWithName:self.search.text];
                [self historyArrAddModel:model];
            }    
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请输入关键字"];
        }
    }
     _historyStr = self.search.text;
}

- (void)creatTableView
{
    
    CGFloat tableY = CGRectGetMaxY(_clikMapBtn.frame)+5;
    NSInteger maxH = kMainScreenSizeHeight-tableY-5;
    UITableView *historyTableView;
    historyTableView  = [[UITableView alloc] initWithFrame:CGRectMake(5, tableY, kMainScreenSizeWidth-10, maxH) style:UITableViewStylePlain];
    historyTableView.showsVerticalScrollIndicator = NO;
    historyTableView.layer.borderWidth = 0.5;
    historyTableView.layer.borderColor = kLayerBorderColor;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    //historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.tableFooterView = [UIView new];
    [self.view addSubview:historyTableView];
    self.historyTableView = historyTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"history";
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.historyArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    historyModel *model = [[historyModel alloc] init];
    model = self.historyArray[indexPath.row];
    [self searchRodeResultWithStr:model.name isCellClicked:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
    [self.historyArray removeObjectAtIndex:indexPath.row];
        
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:HistoryFilePath];
    [self.historyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)poiQueryStart{
//    [SVProgressHUD showWithStatus:@"正在搜索..." maskType:SVProgressHUDMaskTypeNone];
}
-(void)poiQueryFailed{

    [SVProgressHUD showInfoWithStatus:@"搜索失败"];
}
-(void)poiQueryNoResult{

    [SVProgressHUD showInfoWithStatus:@"没有结果"];
}

-(void)poiQueryResultByPage:(NSArray *)result{

    [SVProgressHUD dismissAfterDuration:1.0];
        KCDetailResultController *detailR =[[KCDetailResultController alloc] init];
        detailR.resultArr = result;
        detailR.startPoint = _startPoint;
// index判断是起点输入框还是终点输入框
        detailR.index = self.index;
        [self.navigationController pushViewController:detailR animated:YES];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)buttonTitle
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)historyArrAddModel:(historyModel *)model
{
    [self.historyArray insertObject:model atIndex:0];
    [self.historyTableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:HistoryFilePath];
}

- (void)deleteData
{
    [self.historyArray removeAllObjects];
    [_historyTableView reloadData];
}


- (void)dealloc
{
    _poiQuery.delegate = nil;
}
- (void)back
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
