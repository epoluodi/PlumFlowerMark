//
//  CommonApi.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/6.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "CommonApi.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


static MAPEnum _mapenum;
@implementation CommonApi


+(MAPEnum)getMapEnum
{
    return _mapenum;
}
//返回国家代码
+(void)getCarrierName
{
    CTTelephonyNetworkInfo *ctinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *ctcarrier = [ctinfo subscriberCellularProvider];
    NSLog(@"carrierName:%@",ctcarrier.carrierName);
    if ([ctcarrier.isoCountryCode isEqualToString:@"cn"])
    {
        _mapenum = GAODEMAP;
    }
    else
    {
        _mapenum=GOOLEMAP;
    }
    return ;
}
@end
