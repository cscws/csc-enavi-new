//
//  KCCollectionViewController.m
//  eNavi
//
//  Created by zuotoujing on 16/4/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCCollectionViewController.h"
#import "KCHTTPRspModel.h"
#import "KCRegisterManager.h"
@interface KCCollectionViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableData *mutableData;


@end

@implementation KCCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kVCViewcolor;
    [self setNavigationBar];
    _mutableData = [NSMutableData data];
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

- (IBAction)onClickedTongbu:(UIButton *)sender
{
    NSLog(@"同步");
}
- (IBAction)onClickedBeifen:(UIButton *)sender
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://202.189.1.43:8882/URService/BService?id=321"]cachePolicy:1 timeoutInterval:7];
    
    request.HTTPMethod = @"post";
    
    // boundary可随意命名
    //    NSString *boundary = @"chen";
    
    
    NSMutableArray* poiList = [[NSMutableArray alloc] initWithCapacity:1] ;
    for (int i=0; i<1; i++) {
        NSMutableDictionary* poi = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        [poi setObject:[NSNumber numberWithInt:(i+1)] forKey:@"id"];
        [poi setObject:[NSNumber numberWithDouble:456] forKey:@"lon"];
        [poi setObject:[NSNumber numberWithDouble:123] forKey:@"lat"];
        [poi setObject:@"18930706225" forKey:@"tel"];
        [poi setObject:@"绿地" forKey:@"name"];
        [poi setObject:@"保利" forKey:@"address"];
        [poiList addObject:poi];
    }
    
    //             NSString * temptext = NSLocalizedString(@"正在备份",@"正在备份");
    //             [self.actController.view removeFromSuperview];
    //             [self.actController setLableText:temptext];
    //             [self.navigationController.view addSubview:self.actController.view];
    
    NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"total", poiList, @"backupdata", nil];
    
    NSDictionary* protocolData = [[NSDictionary alloc] initWithObjectsAndKeys:data, @"backups", @"1", @"datatype", nil];
    
    NSData *postData = [self getPostDataWithJsonString:protocolData withEncryptType:KCEncryptTypeDes];
    
    NSString* version =  [KCMainBundle getVersion];
    // 拼接请求头
    [request setValue:[NSString stringWithFormat:@"%@",[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID] key:kDesKey]] forHTTPHeaderField:@"x-up-imsi"];
    [request setValue:[NSString stringWithFormat:@"v%@", version] forHTTPHeaderField:@"x-up-devcap-appinfo"];
    [request setValue:[NSString stringWithFormat:@"iPhone %@", [[UIDevice currentDevice] systemVersion]] forHTTPHeaderField:@"x-up-devcap-platform-id"];
    [request setValue:[KCUtilCoding encryptUseDES:@"18855121624" key:HTTP_HEADER_MDN] forHTTPHeaderField:@"x-up-mdn"];
    
    
    
    // 创建可变data 后面一样拼接
    NSMutableData *myData = [NSMutableData data];
    
    //  NSString *str = [NSString stringWithFormat:@"--%@\n",boundary];
    [myData appendData:postData];
    
    // html页面上传表单里的 <input type="file" name="userfile">
    //    NSString *name = @"userfile";
    //    // 上传后文件的名字
    //    NSString *filename = @"1.zip";
    //
    //    str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n",name,filename];
    //    [myData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    str = @"Content-Type: application/octet-stream\n\n";
    //    [myData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    // bundle中的文件转换成二进制数据
    //    NSURL *uploadFile = [[NSBundle mainBundle]URLForResource:@"music.mp3.zip" withExtension:nil];
    //    [myData appendData:[NSData dataWithContentsOfURL:uploadFile]];
    //
    //    str = [NSString stringWithFormat:@"\n\n--%@--",boundary];
    //    [myData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = myData;
    [[self.session uploadTaskWithRequest:request fromData:myData]resume];
#pragma -----------------
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //    NSString *httpMdn = [user objectForKey:@"httpMdn"];
    
    //    if (NULL == [[KCAuthManager sharedInstance] getUserMdn] && [httpMdn isEqualToString:@""""]) {
    //        [KCUtilENavi alertDefault:@"请先绑定手机号" okBlock:^
    //         {}];
    //
    //        return;
    //    }
    
    //    [KCUtilENavi alertDefault:@"将收藏夹中的内容备份到服务器？" title:@"提示" okBtnTitle:@"确定" okBlock:^
    //     {
    //         if (NULL == comPOIList || comPOIList.count <= 0) {
    //             [KCUtilENavi alertDefault:@"您的本地收藏夹中没有数据" okBlock:^
    //              {}];
    //         } else {
    //             NSMutableArray* poiList = [[NSMutableArray alloc] initWithCapacity:1] ;
    //             for (int i=0; i<1; i++) {
    //                 NSMutableDictionary* poi = [NSMutableDictionary dictionaryWithCapacity:0];
    //
    //                 [poi setObject:[NSNumber numberWithInt:(i+1)] forKey:@"id"];
    //                 [poi setObject:[NSNumber numberWithDouble:456] forKey:@"lon"];
    //                 [poi setObject:[NSNumber numberWithDouble:123] forKey:@"lat"];
    //                 [poi setObject:@"18855121624" forKey:@"tel"];
    //                 [poi setObject:@"绿地" forKey:@"name"];
    //                 [poi setObject:@"保利" forKey:@"address"];
    //                 [poiList addObject:poi];
    //             }
    //
    ////             NSString * temptext = NSLocalizedString(@"正在备份",@"正在备份");
    ////             [self.actController.view removeFromSuperview];
    ////             [self.actController setLableText:temptext];
    ////             [self.navigationController.view addSubview:self.actController.view];
    //
    //             NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"total", poiList, @"backupdata", nil];
    //
    //             NSDictionary* protocolData = [[NSDictionary alloc] initWithObjectsAndKeys:data, @"backups", @"1", @"datatype", nil];
    //
    //             NSData *postData = [self getPostDataWithJsonString:protocolData withEncryptType:KCEncryptTypeDes];
    //    NSDictionary *dicttt = [NSJSONSerialization JSONObjectWithData:postData options:NSJSONReadingMutableContainers error:nil];
    //             NSURL* url = [[NSURL alloc] initWithString:HTTP_BACKUP_POI_URL];
    
    //    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    //   // [dic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    //     NSString *str = [KCUtilCoding encryptUseDES:[protocolData MyJSONString] key:kDesKey];
    //   // [dic setObject:str forKey:@"data"];
    //    dic[@"type"] = [NSNumber numberWithInt:1];
    //    dic[@"data"] = str;
    
    // NSString *postString = [dic MyJSONString];
    
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    ////    [request addRequestHeader:@"x-up-imsi" value:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID] key:kDesKey]];
    //    [manager.requestSerializer setValue:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID] key:kDesKey] forHTTPHeaderField:@"x-up-imsi"];
    //
    
    //    a）手机号：x-up-mdn或x-up-calling-line-id（需要加密传输）
    //    b）imsi：x-up-imsi（需要加密传输）
    //    c）客户端版本：x-up-devcap-appinfo
    //    d）机型信息：x-up-devcap-platform-id（需要加密传输）
    
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //    dict[@"type"]=0;
    //    dict[@"data"] = protocolData;
    //    [manager POST:@"http://platform.enavi.118114.cn:8081/telecomnavi/BService?id=321" parameters:dicttt progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //
    //                     NSLog(@"请求成功 %@", responseObject);
    //
    //                        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //                        NSString* rightJsonStr = [self formatBadJson:jsonStr];
    //                        NSLog(@"处理后的json:%@", rightJsonStr);
    //
    //                        NSDictionary* res = [rightJsonStr objectFromJSONString];
    //
    //                        if(res == nil) // 解析出错
    //                        {
    //                            NSLog(@"解析出错");
    //                        }
    //
    //                        NSNumber* resCode = [res valueForKey:@"result"];
    //                        if ([resCode intValue]!=0) {
    //                            // 服务器返回操作失败
    //                            NSLog(@"服务器返回操作失败");
    //                            NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
    //                            NSString* desc = [resData valueForKey:@"desc"];
    //                            NSLog(@"-----%@----",desc);
    //            //                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@失败:%@", action, desc] okBlock:^
    //            //                 {}];
    //            //                return;
    //                        }
    //                        else
    //                        {
    //            //                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@成功", action] okBlock:^
    //            //                 {}];
    //                           // if (request.tag == TAG_RECOVER) {
    //                                NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
    //                                if (NULL != resData && resData.count > 0) {
    //                                    NSDictionary* backups = [resData valueForKey:@"backups"];
    //                                    if (NULL != backups && backups.count > 0) {
    //                                        NSArray* backupData = [backups valueForKey:@"backupdata"];
    //                                        if (NULL != backupData && backupData.count > 0) {
    //
    //                                            NSLog(@"%lu",(unsigned long)backupData.count);
    //
    //                                            //[self updatePOIList:backupData];
    //                                           // [self.tableView reloadData];
    //            //                                _pTitleView.pBtnRight.enabled = YES;
    //            //                                [_pTitleView setRightImage:[UIImage imageNamed:@"2.6_button_edit.png"]];
    //                                        }
    //                                    }
    //                                }
    //
    //
    //                            }
    //                     //   }
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"888%@",error);
    //    }];
#warning ++++++++
    
    //    [manager POST:@"http://platform.enavi.118114.cn:8081/telecomnavi/BService?id=321" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //        [formData appendPartWithFormData:postData name:@"data"];
    //       // [formData appendPartWithFileData:postData name:@"data" fileName:@"123.json" mimeType:@"application/json"];
    //
    //    } progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //         NSLog(@"请求成功 %@", responseObject);
    //
    //            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //            NSString* rightJsonStr = [self formatBadJson:jsonStr];
    //            NSLog(@"处理后的json:%@", rightJsonStr);
    //
    //            NSDictionary* res = [rightJsonStr objectFromJSONString];
    //
    //            if(res == nil) // 解析出错
    //            {
    //                NSLog(@"解析出错");
    //            }
    //
    //            NSNumber* resCode = [res valueForKey:@"result"];
    //            if ([resCode intValue]!=0) {
    //                // 服务器返回操作失败
    //                NSLog(@"服务器返回操作失败");
    //                NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
    //                NSString* desc = [resData valueForKey:@"desc"];
    //                NSLog(@"-----%@----",desc);
    ////                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@失败:%@", action, desc] okBlock:^
    ////                 {}];
    ////                return;
    //            }
    //            else
    //            {
    ////                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@成功", action] okBlock:^
    ////                 {}];
    //               // if (request.tag == TAG_RECOVER) {
    //                    NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
    //                    if (NULL != resData && resData.count > 0) {
    //                        NSDictionary* backups = [resData valueForKey:@"backups"];
    //                        if (NULL != backups && backups.count > 0) {
    //                            NSArray* backupData = [backups valueForKey:@"backupdata"];
    //                            if (NULL != backupData && backupData.count > 0) {
    //
    //                                NSLog(@"%lu",(unsigned long)backupData.count);
    //
    //                                //[self updatePOIList:backupData];
    //                               // [self.tableView reloadData];
    ////                                _pTitleView.pBtnRight.enabled = YES;
    ////                                [_pTitleView setRightImage:[UIImage imageNamed:@"2.6_button_edit.png"]];
    //                            }
    //                        }
    //                    }
    //
    //
    //                }
    //         //   }
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //         NSLog(@"请求失败 %@", error);
    //    }];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    NSString *jsonStr = [[NSString alloc] initWithData:self.mutableData encoding:NSUTF8StringEncoding];
    NSString* rightJsonStr = [self formatBadJson:jsonStr];
    NSLog(@"处理后的json:%@", rightJsonStr);
    
    NSDictionary* res = [rightJsonStr objectFromJSONString];
    
    if(res == nil) // 解析出错
    {
        NSLog(@"解析出错 res == nil ");
    }
    
    NSNumber* resCode = [res valueForKey:@"result"];
    if ([resCode intValue]!=0) {
        NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
        NSString* desc = [resData valueForKey:@"desc"];
        NSLog(@"-----%@----",desc);
        //                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@失败:%@", action, desc] okBlock:^
        //                 {}];
        //                return;
    }
    else
    {
        //                [KCUtilENavi alertDefault:[NSString stringWithFormat:@"%@成功", action] okBlock:^
        //                 {}];
        // if (request.tag == TAG_RECOVER) {
        NSDictionary* resData = [self getDictionaryFromEncData:[res valueForKey:@"data"]];
        if (NULL != resData && resData.count > 0) {
            NSDictionary* backups = [resData valueForKey:@"backups"];
            if (NULL != backups && backups.count > 0) {
                NSArray* backupData = [backups valueForKey:@"backupdata"];
                if (NULL != backupData && backupData.count > 0) {
                    
                    NSLog(@"%lu",(unsigned long)backupData.count);
                    
                    //[self updatePOIList:backupData];
                    // [self.tableView reloadData];
                    //                                _pTitleView.pBtnRight.enabled = YES;
                    //                                [_pTitleView setRightImage:[UIImage imageNamed:@"2.6_button_edit.png"]];
                }
            }
        }
        
        
    }
    //   }
    
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.mutableData options:NSJSONReadingMutableContainers error:nil];
    //    NSLog(@"-----4");
    //    NSLog(@"%@",dict);
}

// 懒加载
- (NSURLSession *)session
{
    if(_session == nil)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"2");
    [self.mutableData appendData:data];
    NSLog(@"####%lu",(unsigned long)self.mutableData.length);
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSLog(@"1");
    completionHandler(NSURLSessionResponseAllow);
    
}

#pragma mark 3.客户端接收数据完成的时候
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    
    NSLog(@"-----3");
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.mutableData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dict);
}


-(NSDictionary*) getDictionaryFromEncData:(NSString*) data
{
    if (NULL == data || data.length <= 0) {
        return NULL;
    }
    
    NSString* bareStr = [KCUtilCoding decryptUseDES:data key:kDesKey];
    if (NULL == bareStr || bareStr.length <= 0) {
        return NULL;
    }
    
    return [bareStr objectFromJSONString];
}


-(NSString*) formatBadJson:(NSString*) str
{
    return [self formatBadJson:[self formatBadJson:str withBadKey:@"data"] withBadKey:@"des"];
}

-(NSString*) formatBadJson:(NSString*) str withBadKey:(NSString*) key
{
    if (NULL == str || str.length <= 0 || NULL == key || key.length<=0) {
        return NULL;
    }
    
    NSRange dataRange = [str rangeOfString:key];
    if (dataRange.length == 0) {
        return str;
    }
    NSString* subStrFromData = [str substringFromIndex:dataRange.location];
    NSRange begin = [subStrFromData rangeOfString:@":"];
    NSRange end = [subStrFromData rangeOfString:@","];
    begin.location += dataRange.location;
    end.location += dataRange.location;
    
    NSRange range1 = {0, begin.location+1};
    NSRange range2 = {begin.location+1,end.location-begin.location-1};
    NSRange range3 = {end.location, str.length-end.location};
    
    NSString* result = [NSString stringWithFormat:@"%@\"%@\"%@", [str substringWithRange:range1], [str substringWithRange:range2], [str substringWithRange:range3]];
    return result;
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
    }
    
    NSString *postString = [dic MyJSONString];
    NSLog(@"^^^^^^^^%@", postString);
    //    NSLog(@"%@", [data MyJSONString]);
    NSData * tempData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    return tempData;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
