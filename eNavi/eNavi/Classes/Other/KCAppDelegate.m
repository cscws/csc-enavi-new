//
//  KCAppDelegate.m
//  eNavi
//
//  Created by csc on 16/3/3.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCAppDelegate.h"
#import "KCViewController.h"
#import <iNaviCore/MBNaviSession.h>
#import <iNaviCore/MBExpandView.h>
#import "CommonMarco.h"
#import "WXApi.h"
#import <UMMobClick/MobClick.h>
@interface KCAppDelegate ()<MBNaviSessionDelegate,WXApiDelegate>

@end

@implementation KCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:APP_KEY_WEIXIN];
    
    [MBEngine sharedEngine].delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //离线资源的测试key
       // [[MBEngine sharedEngine] checkWithKey:@"dingzm002-20151015-03-L-D-I11100"];
        //在线测试key
        [[MBEngine sharedEngine] checkWithKey:@"dingzm002-20151015-01-Z-D-I11101"];
        NSLog(@"engineVersion:%@",[[MBEngine sharedEngine] version]);
    });
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
  //  [self getPrivateDocsDir];
    
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey = @"575cd0e067e58e18a3000ff5";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    return YES;
}

/**
 *  设置私有路径
 */
- (void)getPrivateDocsDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"mapbar/cn/userdata"];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]){
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

#pragma mark - MBEngineDelegate
#pragma mark - 
/**
 *  授权成功
 */
-(void)sdkAuthSuccessed{
    // 设置根控制器
    UIStoryboard *story = nil;
    story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.window.rootViewController = [story instantiateInitialViewController];
    
    // 防止 poi 参数被意外修改
    MBNaviSession* session = [MBNaviSession sharedInstance];
    MBNaviSessionParams* p = [MBNaviSessionParams defaultParams];
    session.params = p;
    session.delegate = self;
}
/**
 *  授权失败
 *
 *  @param errCode 错误码
 */
-(void)sdkAuthFailed:(MBSdkAuthError)errCode {
    NSLog(@"授权失败,原因:%u", errCode);
    
        UIStoryboard *story = nil;
        story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = [story instantiateInitialViewController];
    
}
/**
 *  启用路口放大图
 */
-(void)naviSessionExpandViewShow{
    [MBExpandView setEnable:YES];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    if([[url absoluteString] hasPrefix:@"wx"]) {
    
        //  处理微信回调需要在具体的 ViewController 中处理。
      //  KCViewController *vc = (KCViewController *)self.window.rootViewController;
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    
    //    KCViewController *vc = (KCViewController *)self.window.rootViewController;
        return [WXApi handleOpenURL:url delegate:self];
        
//    }
}


#pragma mark - 实现代理回调
/**
 *  微博
 *
 *  @param response 响应体。根据 WeiboSDKResponseStatusCode 作对应的处理.
 *  具体参见 `WeiboSDKResponseStatusCode` 枚举.
 */
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    NSString *message;
//    switch (response.statusCode) {
//        case WeiboSDKResponseStatusCodeSuccess:
//            message = @"分享成功";
//            break;
//        case WeiboSDKResponseStatusCodeUserCancel:
//            message = @"取消分享";
//            break;
//        case WeiboSDKResponseStatusCodeSentFail:
//            message = @"分享失败";
//            break;
//        default:
//            message = @"分享失败";
//            break;
//    }
//    showAlert(message);
//}

/**
 *  处理来至QQ的请求
 *
 *  @param req QQApi请求消息基类
 */
//- (void)onReq:(QQBaseReq *)req
//{
//    
//}

/**
 *  处理来至QQ的响应
 *
 *  @param resp 响应体，根据响应结果作对应处理
 */
//- (void)onResp:(QQBaseResp *)resp
//{
//    NSString *message;
//    if([resp.result integerValue] == 0) {
//        message = @"分享成功";
//    }else{
//        message = @"分享失败";
//    }
//    showAlert(message);
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
