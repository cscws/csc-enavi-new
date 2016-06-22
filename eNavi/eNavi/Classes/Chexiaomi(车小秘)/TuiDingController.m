
//  TuiDingController.m
//  eNavi
//
//  Created by zuotoujing on 16/1/13.
//
//

#import "TuiDingController.h"
//#import "KCAuthManager.h"
@interface TuiDingController ()<UIWebViewDelegate>
{
    UIWebView    *_tuiDWeb;
}
@property (nonatomic, copy)NSString *mdn;
@property (nonatomic, copy)NSString *httpMdn;
@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *imsi;
@property (nonatomic, copy)NSString *product;
@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *uperSign;
@property (nonatomic, copy)NSString *urlstr;
@property (nonatomic, copy)NSURL *suurl;
@property (nonatomic ,assign)double i;

//@property (nonatomic, strong)ASIHTTPRequest *requestType;
@end

@implementation TuiDingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTuiDWebView];
}


- (void)loadTuiDWebView
{
    _tuiDWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height-64)];
  // _mdn = [[KCAuthManager sharedInstance] getUserMdn];
   NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _httpMdn = [ user objectForKey:@"httpMdn"];
    if (_mdn==nil && ![_httpMdn isEqualToString:@""""])
    {
        _url = [NSString stringWithFormat:@"http://platform.enavi.118114.cn:8081/TY-web/order/iosUnsubscribe.htm?mdn=%@&imsi=%@" ,_httpMdn,[KCMainBundle getGUDID]];
    }
    else
    {
        _url = [NSString stringWithFormat:@"http://platform.enavi.118114.cn:8081/TY-web/order/iosUnsubscribe.htm?mdn=%@&imsi=%@" ,_mdn,[KCMainBundle getGUDID]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
   // KCLog(@"%@",_url);
    _tuiDWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _tuiDWeb.scalesPageToFit = YES;
    _tuiDWeb.delegate = self;
    [_tuiDWeb loadRequest:request];
    [self.view addSubview:_tuiDWeb];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
