//
//  PublicCommon.h
//  Common
//
//  Created by 程嘉雯 on 15/8/8.
//  Copyright (c) 2015年 com.epoluodi.Common. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///定义不同机型
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


struct Deviceinfo 
{
    __unsafe_unretained NSString * dname;
    __unsafe_unretained NSString * dmodel;
    __unsafe_unretained NSString * uuid;
    
} ;



@interface PublicCommon : NSObject


+(CGRect)GetScreen;
+(CGRect)GetALLScreen;

+(struct Deviceinfo )DeviceName;

+(UIToolbar *)getInputToolbar:(id)sender sel:(SEL)sel;
+(UIImage *)imageFromView: (UIView *) theView atFrame:(CGRect)r;
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+(NSString *)getNow;
+(NSString *)getDateStringWithDT:(NSString *)strDT;
+ (UIImage*) createImageWithColor: (UIColor*) color Rect:(CGRect) rect;
+(NSString *)getDateStringWithFormat:(NSString *)format;
+(NSString *)dateTran:(NSDate *)date;
@end
