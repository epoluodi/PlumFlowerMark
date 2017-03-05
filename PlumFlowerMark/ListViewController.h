//
//  ListViewController.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/5.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ListViewController : BaseViewController
{
    UIBarButtonItem *leftbtn,*rightbtn;
}
@property (weak, nonatomic) IBOutlet UITabBarItem *baritem;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
