//
//  KCWebViewControler.m
//  eNavi
//
//  Created by zuotoujing on 16/5/19.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCWebViewControler.h"
#import "KCUtilCoding.h"
#import "NSString+Hash.h"
#import "TuiDingController.h"
@interface KCWebViewControler ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView    *_webView;
    TuiDingController *_tuiD;
}
@property (nonatomic, copy)NSString *imsi;
@property (nonatomic, copy)NSString *mdn;
@property (nonatomic, copy)NSString *httpMdn;
@property (nonatomic, copy)NSString *product;
@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *uperSign;
@property (nonatomic, copy)NSString *urlstr;
@property (nonatomic, copy)NSURL *suurl;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy)NSString *url;
@property (nonatomic ,assign)double i;
@property (nonatomic, weak)UIToolbar *toolBar;

@end
@implementation KCWebViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    self.navigationController.navigationBar.hidden = YES;
    [self setNavigationBar];
    [self loadWebView];
    _tuiD = [[TuiDingController alloc] init];
    
    // [self loadH5InfoWithBannerUrl:self.url];
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
    titleLabel.text = _controllerType;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
}


- (void)loadWebView
{
    
    if([_controllerType isEqualToString:@"车小秘"])
    {
        [self loadH5InfoWithBannerUrl:ChexiaomiUrl];
    }
    else
    {
        if([_controllerType isEqualToString:@"限行"])
        {
            _url = [NSString stringWithFormat:KCJxuanUrl@"%ld",(long)_code];
        }else if ([_controllerType isEqualToString:@"精选"])
        {
            _url = KCXxingUrl;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        NSLog(@"%@",_url);
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
        [self addWebViewToolBar];
        
    }
}

- (void)loadH5InfoWithBannerUrl:(NSString *)url
{
    //imsi
    _imsi = [KCMainBundle getGUDID];
    //mdn
    _mdn = @"18916271230";
    //httpMdn
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //    _httpMdn = [ user objectForKey:@"httpMdn"];
    //product
    _product = @"324848";
    //时间
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    _i=time;      //NSTimeInterval返回的是double类型
    //key键值
    _key = @"skylead@2015wap";
    
    if (_mdn==nil && ![_httpMdn isEqualToString:@""""])
    {
        _uperSign = [[[NSString stringWithFormat:@"%@%@%@%.0f%@",_imsi,_httpMdn,_product,_i,_key] md5String] uppercaseString];
        _urlstr = [[NSString stringWithFormat:CheckUrl,_imsi,_httpMdn,_product,_i,_uperSign] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _suurl = [NSURL URLWithString:_urlstr];
        [self getDingGouStatusWithURL:_urlstr];
    }
    else
    {
        _uperSign = [[[NSString stringWithFormat:@"%@%@%@%.0f%@",_imsi,_mdn,_product,_i,_key] md5String] uppercaseString];
        
        _urlstr = [[NSString stringWithFormat:CheckUrl,_imsi,_mdn,_product,_i,_uperSign] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        _suurl = [NSURL URLWithString:_urlstr];
        [self getDingGouStatusWithURL:_urlstr];
    }
}

- (void)getDingGouStatusWithURL:(NSString *)url
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:responseObject];
        NSLog(@"%@", dict);
        
        NSString *type = [dict valueForKey:@"type"];
        [User setObject:dict[@"type"] forKey:@"type"];
        if ([type isEqualToString:@"0"])
        {
            
            [self loadCheXiaoMiWebWithInteger:1];
            //                [rightbtn addTarget:self action:@selector(loadMoreWebView) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            [self loadCheXiaoMiWebWithInteger:0];
        }
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"加载失败"];
        [SVProgressHUD dismissAfterDuration:1.0];
    }];
}


//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
//    KCLog(@"%@", dict);
//    NSString *type = [dict valueForKey:@"type"];
//
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setObject:dict[@"type"] forKey:@"type"];
//    if ([type isEqualToString:@"0"])
//    {
//        [_nav setRightText:@"更多"];
//        [self loadCheXiaoMiWebWithInteger:1];
//        [_nav.pBtnRight addTarget:self action:@selector(loadMoreWebView) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        if (_nav.pBtnRight != nil){[_nav.pBtnRight removeFromSuperview];}
//        [self loadCheXiaoMiWebWithInteger:0];
//    }
//}

//    订购首页
//http://platform.enavi.118114.cn:8081/TY-web/cxm/ios.htm?imsi=111-222-333&mdn=&status=0
//    退订页面
//http://platform.enavi.118114.cn:8081/TY-web/order/iosUnsubscribe.htm?mdn=17701264572&imsi=111-222-333&endtime=2016.02.12
#pragma 订购首页
- (void)loadCheXiaoMiWebWithInteger:(NSInteger)status
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    
    if (_mdn==nil && ![_httpMdn isEqualToString:@""""])
    {
        //        NSString *url = [NSString stringWithFormat:@"http://platform.enavi.118114.cn:8081/TY-web/cxm/ios.htm?imsi=%@&mdn=%@&status=%ld",[KCMainBundle getGUDID],_httpMdn,(long)status];
        NSString *url = [NSString stringWithFormat:@"http://202.189.1.43:8882/TY-web/cxm/ios.htm?imsi=%@&mdn=%@&status=%ld",[KCMainBundle getGUDID],_httpMdn,(long)status];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [self createDGWebViewWithRequest:request];
    }
    else
    {
        //        NSString *url = [NSString stringWithFormat:@"http://platform.enavi.118114.cn:8081/TY-web/cxm/ios.htm?imsi=%@&mdn=%@&status=%ld",[KCMainBundle getGUDID],@"18930706225",(long)status];
        NSString *url = [NSString stringWithFormat:@"http://202.189.1.43:8882/TY-web/cxm/ios.htm?imsi=%@&mdn=%@&status=%ld",[KCMainBundle getGUDID],@"18939762707",(long)status];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [self createDGWebViewWithRequest:request];
    }
}

- (void)createDGWebViewWithRequest:(NSURLRequest *)request
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    [self addWebViewToolBar];
    [SVProgressHUD dismissAfterDuration:1.0];
}


- (void)loadMoreWebView
{
    
    [self.navigationController pushViewController:_tuiD animated:YES];
    //[SVProgressHUD showImage:nil status:@"暂时未开通"];
}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    KCLog(@"%@",request.error);
//}
//
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    KCLog(@"didReceiveData----");
//}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"objc://"];
    NSUInteger loc = range.location;
    NSLog(@"***%@",url);
    if (loc != NSNotFound)
    {
        NSString *method = [url substringFromIndex:loc + range.length];
        NSArray *urlComps = [method componentsSeparatedByString:@"/"];
        
        
        if(urlComps.count==1)
        {
            SEL sel = NSSelectorFromString(urlComps[0]);
            [self performSelector:sel withObject:nil afterDelay:0];
        }
        else
        {
            NSLog(@"%@----%@",urlComps[0],urlComps[1]);
            [self cheXiaoMiDingGou:urlComps[1]];
        }
        return NO;
    }
    return YES;
#warning 原版
    //    NSString *url = request.URL.absoluteString;
    //    NSRange range = [url rangeOfString:@"objc://"];
    //    NSUInteger loc = range.location;
    //
    //    if (loc != NSNotFound)
    //    {
    //        NSString *method = [url substringFromIndex:loc + range.length];
    //
    //        NSLog(@"%@",method);
    //        SEL sel = NSSelectorFromString(method);
    //        [self performSelector:sel withObject:nil afterDelay:0];
    //        return NO;
    //    }
    //    return YES;
}


- (void)getChexiaomiList
{
    //    _locPrvdr = [LocationProvider sharedInstance];
    //
    //    KCPlace *kcplace = [[KCPlace alloc] init];
    ////    kcplace.latitude = 31.1552;
    ////    kcplace.longitude = 121.2746;
    //    kcplace.longitude = _locPrvdr.recentLocation.coordinate.longitude;
    //    kcplace.latitude = _locPrvdr.recentLocation.coordinate.latitude;
    //    _list.centerPlace = kcplace;
    //    [self.navigationController pushViewController:_list animated:YES];
}

- (void)cheXiaoMiDingGou:(NSString *)money
{
    NSLog(@"&&&&&&&&&&&&%@",money);
    
    //    [PayInAppManager basicValueByAppId:@"237646650000043718" andPayCode:@"90009790" andPhoneNum:@"18916271230" andState:@"hkajsd" andAppSecret:@"3501dec5824ced5de9c9118ca6afcbc1" object:self];
}


-(void)PhoneCall
{
    
    NSString *phonenumber = @"4008841168";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phonenumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

- (void)addWebViewToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kMainScreenSizeHeight-49, kMainScreenSizeWidth, 49)];
    _toolBar = toolbar;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backToPreview)];
    
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardToNext)];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebView)];
    UIBarButtonItem *f= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[back,forward,f,refresh];
    [self.view addSubview:toolbar];
    
}

- (void)backToPreview
{
    [_webView goBack];
}

- (void)forwardToNext
{
    [_webView goForward];
}
- (void)refreshWebView
{
    [_webView reload];
}

#pragma mark 是否可以加载request请求

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:1 animations:^{
        _toolBar.alpha = 0;
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [UIView animateWithDuration:60 animations:^{
        _toolBar.alpha = 1;
    }];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
