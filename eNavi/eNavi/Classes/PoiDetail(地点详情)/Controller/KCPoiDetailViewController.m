//
//  PoiDetailViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCPoiDetailViewController.h"
#import "AFNetworking.h"
#import "KCRouteViewController.h"
#import "KCAroundMasController.h"
#import "KCNaviViewController.h"
@interface KCPoiDetailViewController ()<NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *ShouCBtn;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation KCPoiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    _nameLabel.text = _name;
    _nameLabel.textColor = kTextFontColor;

    _addressLabel.text = _address;
    _addressLabel.textColor = kTextFontColor;
    if (_phoneNumber.length==0)
    {
    _phoneLabel.text = @"暂无电话";
    }
    else
    {
    _phoneLabel.text = [NSString stringWithFormat:@"电话:%@",_phoneNumber];
    }
    
    _phoneLabel.textColor = kTextFontColor;
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
    titleLabel.text = @"地点详情";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShouCBtnClicked:(UIButton *)sender {
    _isSelected = !_isSelected;
    if (_isSelected==YES)
    {
        _ShouCBtn.selected = YES;
        [self dddd];
    }
    else{
        _ShouCBtn.selected = NO;
        NSLog(@"删除");
    }
}


#warning des加密重写 获取字符串重写
- (void)dddd{
    // 1.URL
    NSURL *url = [NSURL URLWithString:@"http://202.189.1.43:8881/URService/BService?id=321"];
    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 3.请求方法
    request.HTTPMethod = @"POST";
    
    // 4.设置请求体（请求参数）
    
    NSDictionary *orderInfo = @{
                                
                                @"type": @"0",//值为0或者1，0表示不加密，1表示加密
                                @"data": @{
                                        @"datatype":@"1",
                                        @"backups": @{
                                                @"total": @"1",
                                                @"backupdata": @[
                                                        @{
                                                            @"id":@"1",
                                                            @"name": @"保利",
                                                            @"address":@"杨高",
                                                            @"tel": @"18222",
                                                            @"lon":@"116.36946",@"lat": @"39.99258"
                                                            }
                                                        ]}
                                        }
                                };
    NSData *json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;
    
    /**
     [m_request
     addRequestHeader:@"x-up-imsi"
     value:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID]
     key:kDesKey]];
     [m_request addRequestHeader:@"x-up-devcap-appinfo"
     value:[KCMainBundle getVersion]];
     [m_request
     addRequestHeader:@"x-up-mdn"
     value:[KCUtilCoding
     encryptUseDES:
     [[KCAuthManager sharedInstance] getUserMdn]
     key:kDesKey]];
     [dic setObject:[NSString stringWithFormat:@"iPhone %@", [[UIDevice currentDevice] systemVersion]] forKey:@"x-up-devcap-platform-id"];
     */
    // 5.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[KCUtilCoding
                       encryptUseDES:
                       @"18916271230"
                       key:kDesKey] forHTTPHeaderField:@"x-up-mdn"];
    [request setValue:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID]
                                             key:kDesKey] forHTTPHeaderField:@"x-up-imsi"];
    [request setValue:[KCMainBundle getVersion] forHTTPHeaderField:@"x-up-devcap-appinfo"];
    [request setValue:[KCUtilCoding encryptUseDES:[[UIDevice currentDevice] systemVersion] key:kDesKey] forHTTPHeaderField:@"x-up-devcap-platform-id"];
    NSLog(@"%@**%@**%@**%@",[KCUtilCoding
                             encryptUseDES:
                             @"18916271230"
                             key:kDesKey],[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID]
                                                key:kDesKey],[KCMainBundle getVersion],[KCUtilCoding encryptUseDES:[[UIDevice currentDevice] systemVersion] key:kDesKey]);
    // 6.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"******%@",data);
    }];
    
//    NSURLConnection  * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
}


//-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSLog(@"____%@",connection.description);
//}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//
//{
//    NSLog(@"____%@",data);
//}

- (IBAction)zhongDianBtnClicked:(UIButton *)sender {
#pragma cityNode
    KCRouteViewController *routeView = [[KCRouteViewController alloc] init];
    routeView.startPoi = _startPoi;
    routeView.endPoi = _endPoi;
    routeView.endStr = _name;
    [self.navigationController pushViewController:routeView animated:YES];
}

- (IBAction)startNavi:(UIButton *)sender {

    KCNaviViewController *navi = [[KCNaviViewController alloc] init];
    navi.startPoint = _startPoi;
    navi.endPoint = _endPoi;
    navi.index = 0;
    [self.navigationController pushViewController:navi animated:YES];
    
}

- (IBAction)searchAroundBtn:(UIButton *)sender {
    KCAroundMasController *aroundMas = [[KCAroundMasController alloc] init];
    aroundMas.centerPoi = _endPoi;
    [self.navigationController pushViewController:aroundMas animated:YES];
    
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
}

@end
