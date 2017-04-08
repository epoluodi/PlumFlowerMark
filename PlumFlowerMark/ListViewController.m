//
//  ListViewController.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "ListViewController.h"
#import "listCell.h"

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
    
    
    UINib *nib = [UINib nibWithNibName:@"ListCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    table.backgroundColor= [UIColor clearColor];
    table.dataSource = self;
    table.delegate=self;
    
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
    
    [self loadData];
    [table reloadData];
    
}

-(void)loadData
{
    listarry = [[DBmanger getIntance] getPlaceInfoArry];
}
#pragma mark table delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listarry)
        return listarry.count;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    listCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    [cell loadDataPlaceInfo:listarry[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark -


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
