//
//  KCRegisterManager.h
//  eNavi
//
//  Created by Jim on 14-4-2.
//
//

#import <Foundation/Foundation.h>
#import "HttpWebService.h"
#import "KCHTTPRspModel.h"

@protocol  KCRegisterManagerDelegate;

@interface KCRegisterManager : NSObject <HttpWebServiceGetterDelegate>

@property (nonatomic) NSUInteger methodId;

@property (nonatomic, assign) id<KCRegisterManagerDelegate> delegate;
@property (nonatomic, retain) HttpWebService *httpWebService;

/*
 *根据手机号获取验证码
 */
- (void)getVerifyCode:(NSString *)mdn;

- (void)userRegisterMdn:(NSString *)mdn checkCode:(NSString *)checkCode;
- (void)userRegisterMdn:(NSString *)httpMdn;
//- (void)setMdn:(NSString *)mdn;


@end

@protocol KCRegisterManagerDelegate <NSObject>

@required
- (void)registerManager:(KCRegisterManager *)regsiterManager didReceiveModel:(KCHTTPRspModel *)model;
- (void)registerManager:(KCRegisterManager *)registerManager didFailWithErrorString:(NSString *)error;

@end
