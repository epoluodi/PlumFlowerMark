//
//  MainViewController.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navtitle = [[UINavigationItem alloc] init];
    _navtitle.hidesBackButton=YES;
    [self.navigationController.navigationBar pushNavigationItem:_navtitle animated:NO];

    self.tabBar.items[0].title =  NSLocalizedString(@"BarItem1", nil);
    self.tabBar.items[1].title =  NSLocalizedString(@"BarItem2", nil);
}

-(void)setNavTitle:(NSString *)title
{
    _navtitle.title=title;
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
