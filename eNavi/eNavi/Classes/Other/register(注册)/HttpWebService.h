//
//  HttpWebService.h
//  HttpWeb
//
//  Created by zoujz on 11-5-23.
//  Copyright 2011 PDAger.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark ---------------------------------------
#pragma mark HttpWebService Class

@protocol HttpWebServiceGetterDelegate;

/************************************************/
/*			HttpWebService Class				*/
/************************************************/
@interface HttpWebService : NSObject {
	
	//id<HttpWebServiceGetterDelegate> webDelegate;
	
	NSMutableURLRequest	*	webRequest;
	NSURLConnection		*	webConnection;
	NSMutableData		*	webData;
    NSURLResponse		*	webResponse;
}

@property(nonatomic, assign) id<HttpWebServiceGetterDelegate> webDelegate;
@property(nonatomic, retain) NSMutableURLRequest * webRequest;
@property(nonatomic, retain) NSURLConnection * webConnection;
@property(nonatomic, retain) NSMutableData * webData;
@property(nonatomic, retain) NSURLResponse * webResponse;


//
//	init object with delegate-host id
//	return nil if hoster is nil
//
-(id)initWithDelegate:(id)hoster;


//
//	build request with url String
//	return nil if url is nil
//
-(BOOL)HttpWebServiceBuildConnection:(NSString *)urlStr;


//
//	set connection header
//
-(void)HttpWebServiceSetHeader:(NSString *)header
					  forField:(NSString*)headerField;


//
//	set connection with "POST" method and set post data
//
-(void)HttpWebServiceSetPOSTData:(void*)data 
					withDataSize:(NSInteger)datasize;


//
//	start and stop Asynchronous Connection
//	use this method will get HttpWebServiceGetterDelegate call
//	usually use this method
//
-(BOOL)HttpWebServiceStartAsynConnection;
-(void)HttpWebServiceStopAsynConnection;


//
//	start Synchronous Connection
//	use this method will get webdata when the method return
//
-(void)HttpWebServiceStartSynConnection:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))completionHandler;

@end



#pragma mark ------------------------------------------
#pragma mark HttpWebServiceGetterDelegate

#define HTTPWEBSERVICEERR_CONNECTFAIL	1
#define HTTPWEBSERVICEERR_GETEMPTYDATA	2

/************************************************/
/*	Asynchronous Connection get-data delegate	*/
/************************************************/
@protocol HttpWebServiceGetterDelegate <NSObject>
@required
//
//	get this delegate when HttpWebService Get webdata successfully
//
-(void)HttpWebServiceGetDataFinish:(HttpWebService *)webService
						  withData:(NSMutableData*)webdata
					  withDataSize:(NSInteger)datasize;

//
//	get this delegate when HttpWebService Get webdata Failed or Get empty data
//	errcode:
//	1: connect network fail
//	2: get empty data
//
-(void)HttpWebServiceGetDataFailed:(HttpWebService *)webService
					   withErrCode:(NSInteger)errcode;
@end

