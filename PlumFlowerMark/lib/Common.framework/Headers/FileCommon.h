//
//  FileCommon.h
//  Common
//
//  Created by 程嘉雯 on 15/10/22.
//  Copyright © 2015年 com.epoluodi.Common. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCommon : NSObject


//根目录
+(NSString *)getHomeDirectory;
//文档目录
+(NSString *)getDocumentsDirectory;
//缓存目录
+(NSString *)getCacheDirectory;
//tmp目录
+(NSString *)getTempDirectory;


@end
