//
//  RootViewController.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "RootViewController.h"
#import <Common/PublicCommon.h>
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backnavbar = [PublicCommon createImageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3 ] Rect:CGRectMake(0, 0, 100, 60)];
    UIImage *backbar = [PublicCommon createImageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3 ] Rect:CGRectMake(0, 0, 100, 40)];
    [[UINavigationBar appearance] setBackgroundImage:backnavbar forBarMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setTintColor:APPCOLOR];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:APPCOLOR}];
    //设置全局tabbar 选中颜色
    [[UITabBar appearance] setTintColor:APPCOLOR];
    [[UITabBar appearance] setTranslucent:YES];
    [[UITabBar appearance] setBackgroundImage:backbar];
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
