//
//  CommonApi.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/6.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GOOLEMAP,
    GAODEMAP,

} MAPEnum;

@interface CommonApi : NSObject


+(void)getCarrierName;
+(MAPEnum)getMapEnum;
@end
