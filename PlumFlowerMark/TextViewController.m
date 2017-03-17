//
//  TextViewController.m
//  PlumFlowerMark
//
//  Created by Stereo on 2017/3/14.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "TextViewController.h"
#import <Common/PublicCommon.h>

@interface TextViewController ()

@end

@implementation TextViewController
@synthesize navtitle;
@synthesize txtmemo;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    navtitle.title=NSLocalizedString(@"remarktitle", nil);
    
    UIBarButtonItem *btnsave = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnsave"] style:UIBarButtonItemStylePlain target:self action:@selector(Save)];
    [navtitle setRightBarButtonItem:btnsave];
    
    txtmemo.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinputboard)];
    
    // Do any additional setup after loading the view.
}

-(void)Save
{
    if (![txtmemo.text isEqualToString:@""])
        [delegate FinishInput:txtmemo.text];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeinputboard
{
    [txtmemo resignFirstResponder];
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
