//
//  AddViewController.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/6.
//  Copyright © 2017年 杨晓光. All rights reserved.
//
/*
 1.地理位置解析
 2. 经度纬度
 3. 方向信息
 4. 海拔信息
 5. 时间
 6 图片，录音
 
 
 */
#import "AddViewController.h"

@interface AddViewController ()
{
 
    UIBarButtonItem *btn1,*btn2;
}
@end

@implementation AddViewController
@synthesize navtitle;
@synthesize mapview;
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    navtitle.title = NSLocalizedString(@"AddTitle", nil);
    
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    
    btn1 = [[UIBarButtonItem alloc] initWithTitle:@"123" style:UIBarButtonItemStylePlain target:nil action:nil];
    btn2 = [[UIBarButtonItem alloc] initWithTitle:@"123" style:UIBarButtonItemStylePlain target:nil action:nil];
    [navtitle setRightBarButtonItems:@[btn1,btn2]];
    
    mapview.settings.compassButton = YES;
    mapview.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapview addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    _firstLocationUpdate=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        mapview.myLocationEnabled = YES;
    });
    
    // Do any additional setup after loading the view.
}

//释放
- (void)dealloc {
    [mapview removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];

}


//定位通知
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapview.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:16];
    }
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
