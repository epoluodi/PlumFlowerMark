//
//  MainViewController.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface MainViewController : UITabBarController
{
    @public
    UINavigationItem *_navtitle;
    RootViewController *rootview;
}

-(void)setNavTitle:(NSString *)title;
@end
