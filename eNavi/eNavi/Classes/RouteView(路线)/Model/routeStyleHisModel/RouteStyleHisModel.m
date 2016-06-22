//
//  RouteStyleHisModel.m
//  eNavi
//
//  Created by zuotoujing on 16/5/12.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "RouteStyleHisModel.h"

@implementation RouteStyleHisModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_startName forKey:@"startName"];
    [aCoder encodeObject:_midName forKey:@"midName"];
    [aCoder encodeObject:_endName forKey:@"endName"];
    [aCoder encodeObject:_btnType forKey:@"btnType"];
    [aCoder encodeInt:_sX forKey:@"sX"];
    [aCoder encodeInt:_sY forKey:@"sY"];
    
    [aCoder encodeInt:_mX forKey:@"mX"];
    [aCoder encodeInt:_mY forKey:@"mY"];
    
    [aCoder encodeInt:_eX forKey:@"eX"];
    [aCoder encodeInt:_eY forKey:@"eY"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _startName = [aDecoder decodeObjectForKey:@"startName"];
        _midName = [aDecoder decodeObjectForKey:@"midName"];
        _endName = [aDecoder decodeObjectForKey:@"endName"];
        _btnType = [aDecoder decodeObjectForKey:@"btnType"];
        _sX = [aDecoder decodeIntForKey:@"sX"];
        _sY = [aDecoder decodeIntForKey:@"sY"];
        
        _mX = [aDecoder decodeIntForKey:@"mX"];
        _mY = [aDecoder decodeIntForKey:@"mY"];
        
        _eX = [aDecoder decodeIntForKey:@"eX"];
        _eY = [aDecoder decodeIntForKey:@"eY"];
        
    }

    
    return self;
}

@end
