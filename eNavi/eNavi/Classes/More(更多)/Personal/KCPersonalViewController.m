//
//  KCPersonalViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/5/18.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCPersonalViewController.h"
#import "JZSearchBar.h"
#import "KCHTTPRspModel.h"
#import "KCRegisterManager.h"
@interface KCPersonalViewController ()<UITextFieldDelegate,KCRegisterManagerDelegate>
@property (nonatomic, weak) UITextField *phoneTextFeild;
@property (nonatomic, weak) UITextField *codeTextFeild;
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UILabel *errorLabel;
@property (nonatomic, weak) UIButton *postBtn;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) int countDown;

@property (strong, nonatomic) KCRegisterManager *registerManager;
@end
@implementation KCPersonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    self.navigationController.navigationBar.hidden = YES;
    [self setNavigationBar];
    [self addSubView];
    _countDown = 60;
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
    titleLabel.text = @"个人资料";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
}

- (void)addSubView
{
    // UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenSizeWidth, kMainScreenSizeHeight)];
    UIImage *img = [UIImage imageNamed:@"bind_bkg"];
    imgView.image = img;
    imgView.userInteractionEnabled = YES;
    _imgView = imgView;
    [self.view addSubview:_imgView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kMainScreenSizeWidth-10, 160)];
    backView.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    backView.userInteractionEnabled = YES;
    _backView = backView;
    [_imgView addSubview:backView];
    
    JZSearchBar *phoneTextField = [[JZSearchBar alloc] init];
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    phoneTextField.delegate = self;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    // phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.placeholder = @"电话号码";
    self.phoneTextFeild = phoneTextField;
    [_imgView addSubview:phoneTextField];
    
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"请输入11位手机号进行绑定";
    descLabel.font = font(14.0);
    descLabel.textColor = kTextFontColor;
    self.descLabel = descLabel;
    [_imgView addSubview:descLabel];
    
    JZSearchBar *codeTextField = [[JZSearchBar alloc] init];
    codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    //codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [codeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    codeTextField.placeholder = @"验证码";
    codeTextField.delegate = self;
    self.codeTextFeild = codeTextField;
    [_imgView addSubview:codeTextField];
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.backgroundColor = kColor(73, 183, 233, 1);
    codeBtn.clipsToBounds = YES;
    codeBtn.layer.borderWidth = 0.5;
    codeBtn.layer.borderColor = kLayerBorderColor;
    codeBtn.titleLabel.font = font(14.0);
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //  [codeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn addTarget:self action:@selector(getVerifyCodeSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.codeBtn = codeBtn;
    [_imgView addSubview:codeBtn];
    
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.font = font(14.0);
    errorLabel.text = @"号码填写错误";
    errorLabel.textColor = [UIColor redColor];
    errorLabel.hidden = YES;
    self.errorLabel = errorLabel;
    [_imgView addSubview:errorLabel];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"绑定" forState:UIControlStateNormal];
    postBtn.backgroundColor = kColor(73, 183, 233, 1);
    postBtn.clipsToBounds = YES;
    postBtn.layer.borderWidth = 0.5;
    postBtn.layer.borderColor = kLayerBorderColor;
    postBtn.titleLabel.font = font(14.0);
    [postBtn addTarget:self action:@selector(postBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.postBtn = postBtn;
    [_imgView addSubview:postBtn];
    
    [self setsubViewsFrame];
}

- (void)setsubViewsFrame
{
    __weak __typeof(self) weakSelf = self;
    [weakSelf.phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(94);
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [weakSelf.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneTextFeild.mas_bottom);
        make.left.mas_equalTo(weakSelf.phoneTextFeild.mas_left);
        make.right.mas_equalTo(weakSelf.phoneTextFeild.mas_right);
        make.height.mas_equalTo(30);
        
    }];
    
    [weakSelf.codeTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.descLabel.mas_bottom);
        make.left.mas_equalTo(weakSelf.descLabel.mas_left);
        make.height.mas_equalTo(40);
        make.width.equalTo(weakSelf.phoneTextFeild).multipliedBy(0.6);
    }];
    
    [weakSelf.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(weakSelf.codeTextFeild);
        make.left.mas_equalTo(weakSelf.codeTextFeild.mas_right).offset(5);
        make.right.mas_equalTo(weakSelf.phoneTextFeild.mas_right);
    }];
    
    [weakSelf.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.codeTextFeild.mas_bottom);
        make.left.mas_equalTo(weakSelf.codeTextFeild.mas_left);
        make.right.mas_equalTo(weakSelf.codeTextFeild.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [weakSelf.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.errorLabel.mas_bottom).offset(20);
        make.right.left.height.mas_equalTo(weakSelf.phoneTextFeild);
    }];
}

//- (void)codeBtnClicked:(UIButton *)btn
//{
//    if(_codeBtn.selected == YES)return;
//    [self.view endEditing:YES];
//    if(![self validatePhone:_phoneTextFeild.text])
//    {
//        [self performSelector:@selector(delayShowErrorStatus:) withObject:@"请输入正确手机号" afterDelay:0.6];
//    }
//    else
//    {
//        _codeBtn.selected = YES;
//#pragma 计时;
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJishi) userInfo:nil repeats:YES];
//        btn.backgroundColor = kColor(210, 210, 210, 1);
//    //        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//    //        NSString* version =  [KCMainBundle getVersion];
//    //        [dic setObject:[NSString stringWithFormat:@"tianyi_navi_pdager_IP v%@ App", version] forKey:HTTP_HEADER_AGENT];
//    //        [dic setObject:[NSString stringWithFormat:@"v%@", version] forKey:@"x-up-devcap-appinfo"];
//    //        [dic setObject:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID] key:kDesKey] forKey:@"x-up-imsi"];
//    //        [dic setObject:[NSString stringWithFormat:@"iPhone %@", [[UIDevice currentDevice] systemVersion]] forKey:@"x-up-devcap-platform-id"];
//    //        [dic setObject:@"-1,-1,-1" forKey:@"x-up-devcap-brewlicense"];
//    //        [dic setObject:[KCMainBundle getGUDID] forKey:@"x-up-macaddr"];
//    //        [dic setObject:[KCMainBundle getGUDID] forKey:@"x-up-gudid"];
//    //        [dic setObject:[KCUtilCoding encryptUseDES:@"18855121624" key:kDesKey] forKey:HTTP_HEADER_MDN];
//    //        [dic setObject:@"18855121624" forKey:kDesKey];
//    //
//    //        NSLog(@"%@",dic);
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:@"-1,-1,-1" forHTTPHeaderField:@"x-up-devcap-brewlicense"];
//    [manager.requestSerializer setValue:@"v1.0" forHTTPHeaderField:@"x-up-devcap-appinfo"];
//    [manager.requestSerializer setValue:@"iPhone 9.3" forHTTPHeaderField:@"x-up-devcap-platform-id"];
//    [manager.requestSerializer setValue:@"tianyi_navi_pdager_IP v1.0 App" forHTTPHeaderField:@"x-up-agent"];
//
//    [manager.requestSerializer setValue:@"18855121624" forHTTPHeaderField:@"Tianyi_navi_pdager_AN"];
//
//    [manager.requestSerializer setValue:@"1E84497E-615F-453A-A976-C5CBEA9BB00B" forHTTPHeaderField:@"x-up-gudid"];
//
//    [manager.requestSerializer setValue:@"C0E6FF41DC5E2B45DB13E7609C48C137730EF7BDE5EE6B2347C12C9E7CE7225F9AB9F15BCC617A10" forHTTPHeaderField:@"x-up-imsi"];
//    [manager.requestSerializer setValue:@"1E84497E-615F-453A-A976-C5CBEA9BB00B" forHTTPHeaderField:@"x-up-macaddr"];
//    [manager.requestSerializer setValue:@"1EC98B947B7C14366327EB166C6DF21F" forHTTPHeaderField:@"x-up-mdn"];
//
//    NSString *url = [NSString stringWithFormat:@"%@?id=%d", @"http://platform.enavi.118114.cn:8081/telecomnavi/BService", 407];
//    //  NSDictionary *dic = @{@"18855121624" : @"mdn" };
//
//    //        NSString *str = [KCUtilCoding encryptUseDES:@"18855121624" key:@"Tianyi_navi_pdager_AN"];
//    //        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    //        [dict setObject:[NSNumber numberWithInt:1] forKey:@"type"];
//    //        [dict setObject:str forKey:@"data"];
//    //        NSString *postString;
//    //        postString = [self dictionaryToJson:(NSDictionary *)dict];
//    NSData * tempData = [self getPostDataWithJsonString:[NSDictionary dictionaryWithObject:@"18855121624" forKey:@"mdn"] withEncryptType:KCEncryptTypeDes];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:url parameters:tempData progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //NSLog(@"####%@",responseObject);
//        //            NSString *ssss = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//
//        [KCHTTPRspModel httpRspModelWithData:responseObject];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    }
//}

#warning 这里获取验证码
- (void)getVerifyCodeSelected:(id)sender
{
    
    if(_codeBtn.selected == YES)return;
    // [self backgroundAction:nil];
    
    //    if (m_getVerifySelected)
    //    {
    //        return;
    //    }
    
    if (![self validatePhone:_phoneTextFeild.text])
    {
        [self performSelector:@selector(delayShowErrorStatus:) withObject:@"请输入正确手机号" afterDelay:0.6];
    }
    else
    {
        //   [self startTimer];
        _codeBtn.selected = YES;
#pragma 计时;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJishi) userInfo:nil repeats:YES];
        _codeBtn.backgroundColor = kColor(210, 210, 210, 1);
        self.registerManager = [[KCRegisterManager alloc] init];
        self.registerManager.delegate = self;
        self.registerManager.methodId = KCMethodIDGetVerifyCode;
        [self.registerManager getVerifyCode:_phoneTextFeild.text];
    }
}

- (void)registerManager:(KCRegisterManager *)regsiterManager didReceiveModel:(KCHTTPRspModel *)model
{
    if (model == nil)
    {
        return;
    }
    
    if (regsiterManager.methodId == KCMethodIDGetVerifyCode)
    {
        if (![[model.data objectForKey:@"desc"] isEqualToString:@"操作成功"])
        {
            [SVProgressHUD showErrorWithStatus:model.errorMessage];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:[model.data objectForKey:@"desc"]];
        }
        
    }
    else if (regsiterManager.methodId == KCMethodIDUserRegister)
    {
        //        [User setObject:_phoneTextFeild.text forKey:@"mdn"];
        //        [self.navigationController popViewControllerAnimated:YES];
        if (model.result != 0)
        {
            [SVProgressHUD showErrorWithStatus:model.errorMessage];
            if (model.result == 116) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if (userDefaults) {
                    [userDefaults setObject:[model.data objectForKey:@"mdn"] forKey:kUserDefaultsMdnKey];
                    
                    [userDefaults synchronize];
                }
            }
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (userDefaults) {
                [userDefaults setObject:[model.data objectForKey:@"mdn"] forKey:kUserDefaultsMdnKey];
                [userDefaults synchronize];
            }
            [self.navigationController popViewControllerAnimated:YES];
#warning 这里多大括号‘}’
        }
        //
        //            //...
        //            if ([SVProgressHUD isVisible])
        //            {
        //                [SVProgressHUD dismiss];
        //            }
        //
        //            if (self.registerType == KCRegisterTypeAccountManage)
        //            {
        //                KCMainMapController *pParentController = [KCMainMapController sharedInstance];
        //                if(nil != pParentController)
        //                {
        //                    KCAccountShowViewController *accountShowViewController = [[KCAccountShowViewController alloc] initWithNibName:nil bundle:nil];
        //                    KCAutorelease(accountShowViewController);
        //
        //                    [pParentController.navigationController pushViewController:accountShowViewController animated:YES];
        //
        //                    [pParentController.pMainTabMenuView setOpenMoreMenu:NO];
        //                    [pParentController.blackTransluscent removeFromSuperview];
        //                }
        //            }
        ////            else if (self.registerType == KCRegisterTypeNaviSecretary)
        ////            {
        ////                KCMainMapController *pParentController = [KCMainMapController sharedInstance];
        ////                if(nil != pParentController)
        ////                {
        ////                    //替换成胜涛写的导航秘书页面
        ////                    KCNaviSecretaryController *secretaryVC = [[KCNaviSecretaryController alloc] init];
        ////                    KCAutorelease(secretaryVC);
        ////
        ////                    [pParentController.navigationController pushViewController:secretaryVC animated:YES];
        ////
        ////                    [pParentController.pMainTabMenuView setOpenMoreMenu:NO];
        ////                    [pParentController.blackTransluscent removeFromSuperview];
        ////                }
        ////
        ////            }
        //            else if (self.registerType == KCRegisterTypeSignIn)
        //            {
        //                if ([KCAuthManager sharedInstance].bNetReachable == NO)
        //                {
        //                    [SVProgressHUD showImage:nil status:@"请检查网络"];
        //                    return;
        //                }
        //
        //                KCMainMapController *pParentController = [KCMainMapController sharedInstance];
        //                if (nil != pParentController)
        //                {
        //                    [SVProgressHUD showWithStatus:@"正在连接..." maskType:SVProgressHUDMaskTypeClear];
        //                    if ([KCOrderManager hasLocalOrder])
        //                    {
        //                        //给服务器发送本地订单数据
        //                        [KCOrderManager PostOrderToServer];
        //
        //                        //                        if ([SVProgressHUD isVisible])
        //                        //                        {
        //                        //                            [SVProgressHUD dismiss];
        //                        //                        }
        //                        //
        //                        //                        [SVProgressHUD showImage:nil status:@"网络异常"];
        //                        //                        return;
        //                    }
        //
        //                    [[KCAuthManager sharedInstance] userAuthWithblock:^(KCAuthStatus newStatus, NSString *errorMsg) {
        //                        if ([SVProgressHUD isVisible])
        //                        {
        //                            [SVProgressHUD dismiss];
        //                        }
        //
        //                        if (!(newStatus >= KCAuthStatusOrder && newStatus < KCAuthStatusGUDIDChange))
        //                        {
        //                            if (errorMsg == nil || errorMsg.length == 0) {
        //                                errorMsg = @"未知错误";
        //                            }
        //
        //                            FOREGROUND_BEGIN
        //                            [SVProgressHUD showErrorWithStatus:errorMsg];
        //                            FOREGROUND_COMMIT
        //
        //                            return ;
        //                        }
        //
        //                        NSArray *array = [self.navigationController viewControllers];
        //                        UIViewController *vc = [array objectAtIndex:array.count-2];
        //                        if ([vc class] == [KCStoreViewController class]) {
        //                            UIViewController *tempVc = [(KCStoreViewController *)vc showViewController];
        //                            if ([tempVc class] == [KCOrderViewController class]) {
        //                                [(KCOrderViewController *)tempVc cleanView];
        //                            }
        //                        }
        //
        //                        [self.navigationController popViewControllerAnimated:NO];
        //                    }];
        //                }
        //            }//self.registerType == KCRegisterTypeSignIn
        //        }// "注册成功"
    }// regsiterManager.methodId == KCMethodIDUserRegister
}

- (void)registerManager:(KCRegisterManager *)registerManager didFailWithErrorString:(NSString *)error
{
    NSLog(@"%@", error.description);
    [SVProgressHUD showErrorWithStatus:error];
    
    if (registerManager.methodId == KCMethodIDGetVerifyCode) {
        [self.timer invalidate];
    }
}

- (void)postBtnClicked:(UIButton *)btn
{
    btn.backgroundColor = kColor(210, 210, 210, 1);
    
    //    [self backgroundAction:nil];
    
    if (![self validatePhone:_phoneTextFeild.text ])
    {
        [self performSelector:@selector(delayShowErrorStatus:) withObject:@"请输入正确手机号" afterDelay:0.6];
        //        [pPhoneNumTextField becomeFirstResponder];
    }
    else if (![self validateVerifyCode:_codeTextFeild.text])
    {
        [self performSelector:@selector(delayShowErrorStatus:) withObject:@"请输入正确验证码" afterDelay:0.6];
        //        [pVerifyCodeTextField becomeFirstResponder];
    }
    else
    {
        //...
        self.registerManager = [[KCRegisterManager alloc] init];
        self.registerManager.delegate = self;
        self.registerManager.methodId = KCMethodIDUserRegister;
        [self.registerManager userRegisterMdn:_phoneTextFeild.text checkCode:_codeTextFeild.text];
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
    }
}



- (NSData *)getPostDataWithJsonString:(NSDictionary *)data withEncryptType:(KCEncryptType)encyptType
{
    if (data == nil) {
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:encyptType] forKey:@"type"];
    
    if (encyptType == KCEncryptTypeNone)
    {
        [dic setObject:data forKey:@"data"];
    }
    else if (encyptType == KCEncryptTypeDes)
    {
        NSString *str = [KCUtilCoding encryptUseDES:[data MyJSONString] key:kDesKey];
        [dic setObject:str forKey:@"data"];
        NSLog(@"%@",dic);
    }
    
    NSString *postString = [dic MyJSONString];
    
    NSData * tempData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    return tempData;
}

- (BOOL)validateVerifyCode:(NSString *)verifyCode
{
    return verifyCode.length == 6;
}

- (BOOL)validatePhone:(NSString*)phoneString
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    KCLog(@"phonePredicate is %@", phonePredicate);
    return [phonePredicate evaluateWithObject:phoneString];
}

- (void)daoJishi
{
    _countDown--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",_countDown] forState:UIControlStateNormal];
    if(_countDown==0)
    {
        [self.timer invalidate];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.backgroundColor = kColor(73, 183, 233, 1);
        _codeBtn.selected = NO;
        _countDown = 60;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _errorLabel.hidden = YES;
}

- (void)delayShowErrorStatus:(NSString *)msg
{
    [SVProgressHUD showErrorWithStatus:msg];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
