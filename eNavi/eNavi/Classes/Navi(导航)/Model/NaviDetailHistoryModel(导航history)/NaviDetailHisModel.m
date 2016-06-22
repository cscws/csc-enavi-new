//
//  NaviDetailHisModel.m
//  eNavi
//
//  Created by zuotoujing on 16/5/5.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "NaviDetailHisModel.h"
#import "DetailSearchFrameModel.h"
#import "DetailSearchModel.h"

@implementation NaviDetailHisModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_adress forKey:@"adress"];
//    [aCoder encodeCGPoint:_startPoint forKey:@"startPoint"];
//    [aCoder encodeCGPoint:_endPoint forKey:@"endPoint"];
    [aCoder encodeInt:_sX forKey:@"sX"];
    [aCoder encodeInt:_sY forKey:@"sY"];
    [aCoder encodeInt:_eX forKey:@"eX"];
    [aCoder encodeInt:_eY forKey:@"eY"];
    

}

#pragma 被自己坑死
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
      _name = [aDecoder decodeObjectForKey:@"name"];
      _adress = [aDecoder decodeObjectForKey:@"adress"];
//        [aDecoder decodeCGPointForKey:@"startPoint"];
//        [aDecoder decodeCGPointForKey:@"endPoint"];
      _sX = [aDecoder decodeIntForKey:@"sX"];
      _sY = [aDecoder decodeIntForKey:@"sY"];
      _eX = [aDecoder decodeIntForKey:@"eX"];
      _eY = [aDecoder decodeIntForKey:@"eY"];
        
    }
    return self;
}

+ (instancetype)modelWithModel:(DetailSearchFrameModel *)frameModel startPoint:(CGPoint)SPoint
{
    NaviDetailHisModel *model = [[NaviDetailHisModel alloc] init];
    model.name = frameModel.model.name;
    model.adress = frameModel.model.address;
#warning eeeee
    NSLog(@"%@",model.adress);
    model.phoneNumber = frameModel.model.phoneNumber;
    model.eX = frameModel.model.poi.x;
    model.eY = frameModel.model.poi.y;
    model.sX = SPoint.x;
    model.sY = SPoint.y;
//    model.startPoint = SPoint;
//    model.endPoint = EPoint;
    return model;
}

@end
