//
//  RegularString.h
//  Common
//
//  Created by 程嘉雯 on 15/12/5.
//  Copyright © 2015年 com.epoluodi.Common. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularString : NSObject


+(BOOL)ValidateEmail:(NSString *)email;
+(BOOL)ValidIP:(NSString *)ip;
@end
