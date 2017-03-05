//
//  Public.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]





//当前APP相关定义
#define APPCOLOR UIColorFromRGB(0x17abe3) //主色调标题栏，button
#define APPCOLOR2 UIColorFromRGB(0x98d4ea) //主色调标题栏，button

