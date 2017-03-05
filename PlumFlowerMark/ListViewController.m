//
//  ListViewController.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    

    leftbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    [mainview->_navtitle setLeftBarButtonItem:leftbtn];
    
    rightbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftbtn1"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    [mainview->_navtitle setRightBarButtonItem:rightbtn];
    
    
    _baritem.title = NSLocalizedString(@"BarItem1", nil);
    
    
    
    table.backgroundColor= [UIColor clearColor];
    
    
    // Do any additional setup after loading the view.
}


//bar evet
-(void)clickLeftBtn
{
    [self performSegueWithIdentifier:@"showabout" sender:nil];
}

-(void)clickRightBtn
{
    [self performSegueWithIdentifier:@"showadd" sender:nil];
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        self.navigationController.navigationBar.hidden=NO;
    [mainview setNavTitle:NSLocalizedString(@"Tab1Title", nil)];
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
