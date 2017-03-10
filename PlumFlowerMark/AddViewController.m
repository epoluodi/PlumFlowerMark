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
#import <Common/PublicCommon.h>

@interface AddViewController ()
{
 
    UIBarButtonItem *btn1,*btn2,*btn3;
    CLLocation *myloc;
    int rows;
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
    
    imglist = [[NSMutableArray alloc] init];
    imgidlist = [[NSMutableArray alloc] init];
    
    labaddr = [[UILabel alloc] init];
    lablnglat = [[UILabel alloc] init];
    labaltitude = [[UILabel alloc] init];
    labangleStr = [[UILabel alloc] init];
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    btn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnsave"] style:UIBarButtonItemStylePlain target:nil action:nil];
    btn2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btncamera"] style:UIBarButtonItemStylePlain target:nil action:nil];
    btn3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnrecord"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRecord)];
    [navtitle setRightBarButtonItems:@[btn1,btn2,btn3]];
    
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
    
    rows=6;
    
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor = [UIColor clearColor];
    locaddress = nil;
    

    // Do any additional setup after loading the view.
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (effectview){
        [UIView animateWithDuration:0.3 animations:^{
                  effectview.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [effectview removeFromSuperview];
            [ezview viewUnload];
            [ezview removeFromSuperview];
            ezview=nil;
            effectview=nil;
        }];
    }
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
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (myloc.coordinate.latitude != location.coordinate.latitude &&
        myloc.coordinate.longitude != location.coordinate.longitude)
    {
        GMSGeocoder *geo =[GMSGeocoder geocoder];
        [geo reverseGeocodeCoordinate:location.coordinate completionHandler:^(GMSReverseGeocodeResponse * geocode, NSError * err) {
            if (err)
                return ;
            NSLog(@"%@",[geocode firstResult]);
            GMSAddress *address = [geocode firstResult];
            labaddr.text =[NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,(address.thoroughfare)?address.thoroughfare:@""
                           ];
            labaddr.textColor=[UIColor whiteColor];
        }];
    }
    myloc= location;
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;

    
//        location.coordinate;  //经纬度
        NSLog(@"海拔 %f",location.altitude); //海拔
//        location.horizontalAccuracy;  //如果是负值，代表当前位置数据不可用
//        location.verticalAccuracy; //如果是负值，代表当前海拔数据不可用
        NSLog(@"航向 %f",location.course); //航向（0.0-359.9）
        NSLog(@"速度 %f",location.speed); //速度
        mapview.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:16];
    }
    

    
    
    lnglat = [NSString stringWithFormat:@"lat:%f lng:%f",myloc.coordinate.latitude,
              myloc.coordinate.longitude];
    altitude = [NSString stringWithFormat:@"%d m (%@)",(int)myloc.altitude,NSLocalizedString(@"altitude", nil)];
    if (myloc.course==0)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course1", nil)];
    else if (myloc.course>0 && myloc.course<90)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course2", nil)];
    else if (myloc.course==90)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course3", nil)];
    else if (myloc.course>90 && myloc.course<180)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course4", nil)];
    else if (myloc.course ==180)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course5", nil)];
    else if (myloc.course >180 && myloc.course < 270)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course6", nil)];
    else if (myloc.course ==270)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course7", nil)];
    else if (myloc.course >270 && myloc.course < 360)
        angleStr =[NSString stringWithFormat:@"%f(%@)",myloc.course, NSLocalizedString(@"course8", nil)];

    lablnglat.text=lnglat;
    labaltitude.text=altitude;
    labangleStr.text =angleStr;
    
}



//table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 80;
        case 1:
        case 2:
        case 3:
            return 60;
        case 4:
        case 5:
            return 80;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *lab;
    UIView *line;
    switch (indexPath.row) {
        case 0:
    
            labaddr.frame  = CGRectMake(50, 0, [PublicCommon GetALLScreen].size.width-100, 80);
            labaddr.textAlignment= NSTextAlignmentCenter;
            labaddr.numberOfLines=2;
            labaddr.lineBreakMode = NSLineBreakByTruncatingTail;
            if (locaddress){
                labaddr.text=locaddress;
                labaddr.textColor= [UIColor whiteColor];
            }
            else
            {
                labaddr.text=NSLocalizedString(@"loadAddress", nil);
                labaddr.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            }
            [cell.contentView addSubview:labaddr];
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, 79, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;
        case 1:
 
            lablnglat.frame  = CGRectMake(40, 0, [PublicCommon GetALLScreen].size.width-80, 60);
            lablnglat.textAlignment= NSTextAlignmentCenter;
            lablnglat.numberOfLines=1;
            lablnglat.text=lnglat;
            lablnglat.textColor= [UIColor orangeColor];
            [cell.contentView addSubview:lablnglat];
            break;
        case 2:
      
            labaltitude.frame  = CGRectMake(40, 0, [PublicCommon GetALLScreen].size.width-80, 60);
            labaltitude.textAlignment= NSTextAlignmentCenter;
            labaltitude.numberOfLines=1;
            labaltitude.text=altitude;
            labaltitude.textColor= [UIColor yellowColor];
            [cell.contentView addSubview:labaltitude];
            break;
        case 3:
      
            labangleStr.frame  = CGRectMake(40, 0, [PublicCommon GetALLScreen].size.width-80, 60);
            labangleStr.textAlignment= NSTextAlignmentCenter;
            labangleStr.numberOfLines=1;
            labangleStr.text=angleStr;
            labangleStr.textColor= [UIColor greenColor];
            [cell.contentView addSubview:labangleStr];
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, 59, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;
        case 4:
   
            if (imglist.count > 0){
                
            }
            else
            {
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 0, [PublicCommon GetALLScreen].size.width-100, 80);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=2;
   
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"nojpg", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            }
            [cell.contentView addSubview:lab];
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, 79, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;
        case 5:
      
            if (recordpath){
                
            }
            else
            {
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 0, [PublicCommon GetALLScreen].size.width-100, 80);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=2;
         
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"noaudio", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            }
            [cell.contentView addSubview:lab];

            break;
    }
    
    return cell;
}





//开始录音
-(void)clickRecord
{
    
    if (effectview)
        return;
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
 
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, table.frame.size.height , table.frame.size.width, 120);
    [table addSubview:effectview];
    
    NSArray *arry = [[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:nil options:nil];
    ezview = arry[0];
    ezview.frame = CGRectMake(0, 0, effectview.frame.size.width, effectview.frame.size.height);
    [effectview addSubview:ezview];
    
    [UIView animateWithDuration:0.2 animations:^{
        effectview.transform = CGAffineTransformMakeTranslation(0, -120);
    }];
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
