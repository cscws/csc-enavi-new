//
//  KCHTTPRspModel.h
//  eNavi
//
//  Created by Jim on 14-4-4.
//
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, KCMethodID)
{
    KCMethodIDGetVerifyCode = 407,
    KCMethodIDUserRegister  = 408,
    
    KCMethodIDOrder         = 332,
    KCMethodIDUserAuth      = 330
};

typedef NS_OPTIONS(NSUInteger, KCEncryptType)
{
    KCEncryptTypeNone = 0,
    KCEncryptTypeDes  = 1
};


@interface KCHTTPRspModel : NSObject

@property (nonatomic, assign) int result;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, copy) NSString *errorMessage;

+ (KCHTTPRspModel *)httpRspModelWithData:(NSData *)data;

@end
