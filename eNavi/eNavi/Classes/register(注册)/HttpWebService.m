//
//  HttpWebService.m
//  HttpWeb
//
//  Created by zoujz on 11-5-23.
//  Copyright 2011 PDAger.Inc. All rights reserved.
//

#import "HttpWebService.h"
#import "PubDefine.h"
//#import "PubDataMgr.h"
#import "PubLink.h"
//#import "KCUtilURL.h"
#import "KCUtilENavi.h"
#import "KCMainBundle.h"
#import "KCUtilCoding.h"
#import "NaviDefine.h"

//typedef void (^HttpWebServiceCompletionHander)(NSURLResponse *response, NSData *responseData, NSError *error);


#define WEBREQUEST_TIMEOUT_INTERVAL	(60)	// 60 seconds

@interface HttpWebService (PrivateMethod)

//@property (nonatomic, copy) HttpWebServiceCompletionHander completionHandler;

- (void)setNetworkActivity:(BOOL)bActive;
@end


@implementation HttpWebService
@synthesize webDelegate, webData;
@synthesize webRequest, webConnection, webResponse;

//
//	init object with delegate-host id
//	return nil if hoster is nil
//
-(id)initWithDelegate:(id)hoster
{
	if(nil == hoster)
		return nil;
	
	if(self = [super init])
	{
		webDelegate = hoster;
		webData = nil;
		webRequest = nil;
		webConnection = nil;
        webResponse = nil;
	}
	
	return self;
}

//	
//	release
//
-(void)dealloc
{
	if(nil != webData){
	//	[webData release];
		webData = nil;
	}
	
	if(nil != webConnection){
	//	[webConnection release];
		webConnection = nil;
	}
	
	if(nil != webRequest){
		//if(0 != [webRequest retainCount])
		//	[webRequest release];
		webRequest = nil;
	}
	
	if(nil != webDelegate){
		webDelegate = nil;
	}
    
    if (nil != webResponse) {
    //    [webResponse release];
        webResponse = nil;
    }
	
	//[super dealloc];
}


//
//	build request with url
//	return nil if url is nil
//
-(BOOL)HttpWebServiceBuildConnection:(NSString *)urlStr
{
	BOOL bRes = NO;
	
	if(nil == urlStr || 0 == urlStr.length)
		return bRes;
	
	NSURL * url = [NSURL URLWithString:urlStr];
	if(nil == url)
		return bRes;
	
	NSMutableURLRequest * urlRqt = [NSMutableURLRequest requestWithURL:url 
														   cachePolicy:NSURLRequestUseProtocolCachePolicy 
													   timeoutInterval:(double)WEBREQUEST_TIMEOUT_INTERVAL];
	if(nil == urlRqt)
		return bRes;
    
    [urlRqt setAllHTTPHeaderFields:[KCUtilENavi getHeaderInfo]];
	
	self.webRequest = urlRqt;
	
	bRes = YES;
	return bRes;
}


-(void)HttpWebServiceSetHeader:(NSString*)header
					  forField:(NSString*)headerField
{
	if(nil == header || 0 == [header length]
	   || nil == headerField || 0 == [headerField length])
		return ;
	
	[webRequest setValue:header	forHTTPHeaderField:headerField];
	
	return ;
}


-(void)HttpWebServiceSetPOSTData:(void*)data
					withDataSize:(NSInteger)datasize
{
	if(nil == webRequest || datasize < 0)
		return ;
	
	[webRequest setHTTPMethod:@"POST"];
	
	if(nil != data)
	{
        NSData * postdata = [[NSData alloc] initWithBytes:data length:datasize];
        
		[webRequest setHTTPBody:postdata];
		
		//[postdata release];
	}
	
	return ;
}


-(BOOL)HttpWebServiceStartAsynConnection
{
	BOOL bRes = NO;
	if(nil == webRequest)
		return bRes;
	
	NSURLConnection	* urlCon = [[NSURLConnection alloc] initWithRequest:webRequest 
															   delegate:self];
	NSLog(@"链接地址：%@",[[webRequest URL] absoluteString]);
	if(nil != urlCon)
	{
		self.webConnection = urlCon;
	//	[urlCon release];
		
		self.webData = [NSMutableData data];
		bRes = YES;
		
		[webConnection start];
		
		[self setNetworkActivity:YES];
	}
	return bRes;
}


-(void)HttpWebServiceStopAsynConnection
{
	if(nil == webConnection)
		return ;
	
	[webConnection cancel];
	[self setNetworkActivity:NO];
}


-(void)HttpWebServiceStartSynConnection:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))completionHandler
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse * webSynRes = nil;
        NSError * webSynErr = nil;
        
        if(nil == webRequest)
        {
            if (completionHandler) {
                completionHandler(webSynRes, nil, webSynErr);
            }

            return;
        }
        
        if(nil != webData){
        //    [webData release];
            webData = nil;
        }
        
        NSMutableURLRequest* requestTmp = [[NSMutableURLRequest alloc] init]; //[[NSMutableURLRequest alloc] initWithURL:webRequest.URL];
//        [requestTmp setAllHTTPHeaderFields:webRequest.allHTTPHeaderFields];
//        [requestTmp setTimeoutInterval:webRequest.timeoutInterval];
//        [requestTmp setHTTPBody:webRequest.HTTPBody];
//        
//        KCLog(@"***%@", requestTmp.allHTTPHeaderFields);
//        KCLog(@"%@", requestTmp.URL);
//        
//        KCLog(@"***%@", webRequest.allHTTPHeaderFields);
//        KCLog(@"%@", webRequest.URL);

        
        NSMutableData *webDataTmp = [NSMutableData dataWithData:[NSURLConnection sendSynchronousRequest:requestTmp
                                                                         returningResponse:&webSynRes
                                                                                    error:&webSynErr]];
     //   KCRelease(requestTmp);
        
        if (completionHandler) {
            completionHandler(webSynRes, webDataTmp, webSynErr);
        }
        
        return;

    });
}

#pragma mark PrivateMethod
- (void)setNetworkActivity:(BOOL)bActive
{
	UIApplication * app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = bActive; 
}

#pragma mark ************ NSURLConnection Asynchronous Delegate Method ********************
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength:0];
    self.webResponse = response;
    
//	KCLog(@"did get response!");
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)urlData
{
	[webData appendData:urlData];
//	KCLog(@"did receive data!");
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"connection failed:%@!\n", [error localizedDescription]);
	if(nil != self.webDelegate)
		[self.webDelegate HttpWebServiceGetDataFailed:self withErrCode:HTTPWEBSERVICEERR_CONNECTFAIL];
	
	[self setNetworkActivity:NO];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try
    {
        if(nil != self.webDelegate)
        {
            if(webData.length > 0)
            {
                if ([self.webResponse class] == [NSHTTPURLResponse class])
                {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.webResponse;
                    if (response.statusCode == 200)
                    {
                        [self.webDelegate HttpWebServiceGetDataFinish:self withData:webData withDataSize:webData.length];
                    }
                    else
                    {
                        [self.webDelegate HttpWebServiceGetDataFailed:self withErrCode:response.statusCode];
                    }
                }
            }
            else
                [self.webDelegate HttpWebServiceGetDataFailed:self withErrCode:HTTPWEBSERVICEERR_GETEMPTYDATA];
        }
        
        [self setNetworkActivity:NO];
    }
    @catch (NSException *exception)
    {
        NSLog(@"connectionDidFinishLoading:%@", exception.description);
    }
    @finally
    {
        
    }

}



@end
