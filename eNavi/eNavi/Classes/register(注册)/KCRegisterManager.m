//
//  KCRegisterManager.m
//  eNavi
//
//  Created by Jim on 14-4-2.
//
//

#import "KCRegisterManager.h"
#import "PubLink.h"
#import "KCUtilCoding.h"
#import "NaviDefine.h"
#import "JSONKit.h"


////#define KCBServiceUrl @"http://10.5.54.41:8080/URService/BService"
//#define KCBServiceUrl @"http://106.3.73.14/URService/BService"

@implementation KCRegisterManager

+ (NSData *)getPostDataWithJsonString:(NSDictionary *)data withEncryptType:(KCEncryptType)encyptType
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
    NSLog(@"%@", postString);
    NSData * tempData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    return tempData;
}

- (id)init
{
    if (self = [super init])
    {
        self.httpWebService = [[HttpWebService alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)getVerifyCode:(NSString *)mdn
{
    if (nil == mdn)
    {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%ld", KCBServiceUrl, (unsigned long)KCMethodIDGetVerifyCode];
    if ([self.httpWebService HttpWebServiceBuildConnection:url])
    {
//        NSString *mdnString = [KCUtilCoding encryptUseDES:mdn key:kDesKey];
//        [self.httpWebService.webRequest setValue:mdnString forHTTPHeaderField:HTTP_HEADER_MDN];
        
        NSData *postData = [KCRegisterManager getPostDataWithJsonString:[NSDictionary dictionaryWithObject:mdn forKey:@"mdn"] withEncryptType:KCEncryptTypeDes];
        [self.httpWebService HttpWebServiceSetPOSTData:(void *)postData.bytes withDataSize:[postData length]];
        if ([self.httpWebService HttpWebServiceStartAsynConnection])
        {
            NSLog(@"HttpWebServiceStartAsynConnection done");
        }
        else
        {
            NSLog(@"HttpWebServiceStartAsynConnection failed");
        }
    }
}

- (void)userRegisterMdn:(NSString *)mdn checkCode:(NSString *)checkCode
{
    if (nil == mdn)
    {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%lu", KCBServiceUrl, (unsigned long)KCMethodIDUserRegister];
    
    if ([self.httpWebService HttpWebServiceBuildConnection:url])
    {
//        NSString *mdnString = [KCUtilCoding encryptUseDES:mdn key:kDesKey];
//        [self.httpWebService.webRequest setValue:mdnString forHTTPHeaderField:HTTP_HEADER_MDN];

        NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:mdn, @"mdn",
                                  checkCode, @"checkCode",
                                  @"123456", @"password",
                                  nil];
        NSData *postData = [KCRegisterManager getPostDataWithJsonString:postDict withEncryptType:KCEncryptTypeDes];
        [self.httpWebService HttpWebServiceSetPOSTData:(void *)postData.bytes withDataSize:[postData length]];
        if ([self.httpWebService HttpWebServiceStartAsynConnection])
        {
            NSLog(@"HttpWebServiceStartAsynConnection done");
        }
        else
        {
            NSLog(@"HttpWebServiceStartAsynConnection failed");
        }
    }
}

- (void)userRegisterMdn:(NSString *)httpMdn
{
        
        NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:httpMdn, @"mdn",
            @"123456", @"password",
            nil];
    //NSLog(@"%@",postDict);
        NSData *postData = [KCRegisterManager getPostDataWithJsonString:postDict withEncryptType:KCEncryptTypeDes];
        [self.httpWebService HttpWebServiceSetPOSTData:(void *)postData.bytes withDataSize:[postData length]];
}


#pragma mark
- (void)HttpWebServiceGetDataFinish:(HttpWebService *)webService withData:(NSMutableData *)webdata withDataSize:(NSInteger)datasize
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerManager:didReceiveModel:)])
    {
        [self.delegate registerManager:self didReceiveModel:[KCHTTPRspModel httpRspModelWithData:webdata]];
    }
    
}

- (void)HttpWebServiceGetDataFailed:(HttpWebService *)webService withErrCode:(NSInteger)errcode
{
    NSLog(@"webservice failed error - %ld",(long)errcode);
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerManager:didFailWithErrorString:)])
    {
        NSString *errStr = nil;
        if (errcode == HTTPWEBSERVICEERR_CONNECTFAIL)
        {
            errStr = @"连接失败";
        }
        else if (errcode == HTTPWEBSERVICEERR_GETEMPTYDATA)
        {
            errStr = @"返回数据为空";
        }
        else
        {
            errStr = [NSHTTPURLResponse localizedStringForStatusCode:errcode];
        }
        
        [self.delegate registerManager:self didFailWithErrorString:errStr];
    }
}

- (void)dealloc
{
    self.httpWebService.webDelegate = nil;
  //  KCDealloc(super);
}

@end
