//
//  LoadingView.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>


@interface LoadingView : UIView
{
    UIImageView *image;
}

-(void)setImages:(__strong NSArray *)images;
-(void)StartAnimation;
-(void)StopAnimation;
@end
