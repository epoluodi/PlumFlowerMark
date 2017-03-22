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
#import <Common/FileCommon.h>

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
    marktype = MARK;
    imgidlist = [[NSMutableArray alloc] init];
    
    labaddr = [[UILabel alloc] init];
    lablnglat = [[UILabel alloc] init];
    labaltitude = [[UILabel alloc] init];
    labangleStr = [[UILabel alloc] init];
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    btn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnsave"] style:UIBarButtonItemStylePlain target:nil action:nil];
    btn2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btncamera"] style:UIBarButtonItemStylePlain target:self action:@selector(showSheet)];
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
    
    rows=8;
    
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor = [UIColor clearColor];
    locaddress = nil;
    
    remarkcellheight= 80;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(audioview)
      [ audioview viewResume];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (effectview){
        [effectview removeFromSuperview];
        [ezview viewUnload];
        [ezview removeFromSuperview];
        ezview=nil;
        effectview=nil;
    }
    if(audioview)
        [ audioview viewPause];
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
    if(audioview)
        [ audioview playStop];
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
            return 80;

        case 5:
            return (remarkcellheight<80)?80:remarkcellheight;
        case 6:
            if (imgidlist.count ==0)
                return 80;
            return 16 + ((imgidlist.count *380) + (imgidlist.count *8) );
        case 7:
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
    int _height=0;
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
            
            if (selectmarktype){

                UIImageView *imgview=  [[UIImageView alloc] init];
                imgview.image= [UIImage imageNamed:selectmarktype];
                imgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
                imgview.contentMode = UIViewContentModeScaleAspectFill;
                imgview.frame= CGRectMake([PublicCommon GetALLScreen].size.width /2 -30, 10, 60, 60);
                [cell.contentView addSubview:imgview];
            
            }
            else
            {
                
                UIButton *btnadd = [[UIButton alloc] init];
                btnadd.frame =CGRectMake( [PublicCommon GetALLScreen].size.width /2 - 10, 16, 20, 20);
                [btnadd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [btnadd addTarget:self action:@selector(showSheetForType
                                                        ) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnadd];
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 80-35, [PublicCommon GetALLScreen].size.width-100, 30);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=2;
                
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"grouptype", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
                [cell.contentView addSubview:lab];
            }
            
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, (remarkcellheight<80)?80:remarkcellheight-1, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;

        case 5:
   
            if (remark){
                if (!labremark){
                    labremark = [[UILabel alloc] init];
                    labremark.font = [UIFont systemFontOfSize:18];
    
                    labremark.textColor = [UIColor whiteColor];
                    labremark.numberOfLines=0;
                }
                labremark.frame = CGRectMake(35, 10, remarkRect.size.width, remarkRect.size.height);
                labremark.text = remark;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                [cell.contentView addSubview:labremark];
            }
            else
            {
                
                UIButton *btnadd = [[UIButton alloc] init];
                btnadd.frame =CGRectMake( [PublicCommon GetALLScreen].size.width /2 - 10, 16, 20, 20);
                [btnadd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [btnadd addTarget:self action:@selector(showInputTextView
                                                        ) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnadd];
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 80-35, [PublicCommon GetALLScreen].size.width-100, 30);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=2;
   
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"noremark", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
                [cell.contentView addSubview:lab];
            }
   
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, (remarkcellheight<80)?80:remarkcellheight-1, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;
        case 6:
            _height=79;
            if (imgidlist.count > 0){
                int index=0;
                for (NSString *filepath in imgidlist) {
                    UIButton *btndeleteimg= [[UIButton alloc] init];
                    UIImageView *imgview = [[UIImageView alloc] init];
                    imgview.frame = CGRectMake(35, 8 + ((index *380) + (index *8) ), [PublicCommon GetALLScreen].size.width-70, 380);
                    NSData *jpg = [NSData dataWithContentsOfFile:filepath];
                    imgview.image = [UIImage imageWithData:jpg];
                    imgview.contentMode = UIViewContentModeScaleAspectFit;
                    [cell.contentView addSubview:imgview];
                    imgview.clipsToBounds=YES;
                    btndeleteimg.frame = CGRectMake(imgview.frame.size.width/2 -20, imgview.frame.size.height-40 , 40, 40);
                    btndeleteimg.alpha=0.6f;
                    btndeleteimg.userInteractionEnabled=YES;
                    imgview.userInteractionEnabled=YES;
                    btndeleteimg.tag = index;
                    [btndeleteimg addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
                    [btndeleteimg setImage: [UIImage imageNamed:@"deletephoto"] forState:UIControlStateNormal];
                    [imgview addSubview:btndeleteimg];
                    index++;
                }
                _height = imgidlist.count *380+ (index *8)  +16 -1;
            }
            else
            { 
                UIButton *btnadd = [[UIButton alloc] init];
                btnadd.frame =CGRectMake( [PublicCommon GetALLScreen].size.width /2 - 10, 16, 20, 20);
                [btnadd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [btnadd addTarget:self action:@selector(showSheet
                                                        ) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnadd];
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 80-35, [PublicCommon GetALLScreen].size.width-100, 30);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=2;
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"nojpg", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
                [cell.contentView addSubview:lab];
            }
            line = [[UIView alloc] init];
            line.frame= CGRectMake(30, _height, [PublicCommon GetALLScreen].size.width-60, 1);
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            [cell.contentView addSubview:line];
            break;

        case 7:
      
            if (recordpath){
                if (!audioview)
                {
                    audioview = [[EZAudioView alloc] initAudioView:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, 80)];
                }
                [audioview updateRecordInfo:recorduuid];
                [cell.contentView addSubview:audioview];
            }
            else
            {
                UIButton *btnadd = [[UIButton alloc] init];
                btnadd.frame =CGRectMake( [PublicCommon GetALLScreen].size.width /2 -10, 16, 20, 20);
                [btnadd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [btnadd addTarget:self action:@selector(clickRecord) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnadd];
                lab = [[UILabel alloc] init];
                lab.frame  = CGRectMake(50, 80-35, [PublicCommon GetALLScreen].size.width-100, 30);
                lab.textAlignment= NSTextAlignmentCenter;
                lab.numberOfLines=1;
                lab.lineBreakMode = NSLineBreakByTruncatingTail;
                lab.text=NSLocalizedString(@"noaudio", nil);
                lab.textColor= [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            }
            [cell.contentView addSubview:lab];
            break;
    }
    
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 4:
            if (selectmarktype)
                return UITableViewCellEditingStyleDelete;
            break;
        case 5:
            if (remark)
                return   UITableViewCellEditingStyleDelete;
            break;
        case 7:
            if (recordpath)
                return   UITableViewCellEditingStyleDelete;
            break;

    }
    return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 4:
            if (selectmarktype)
            {
                [self showSheetForType];
            }
            break;
        case 5:
            if (remark)
            {
                [self showInputTextView];
            }
            break;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
/////////////




/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    switch (indexPath.row) {
        case 4:
            selectmarktype=nil;
            [table beginUpdates];
            [table reloadData];
            [table endUpdates];
            break;
        case 5:
            remark = nil;
            [labremark removeFromSuperview];
            labremark = nil;
            [table beginUpdates];
            [table reloadData];
            [table endUpdates];
            break;
        case 7:
            if (recordpath)
            {
                if (audioview)
                {
                    [audioview viewPause];
                    [audioview removeFromSuperview];
                    audioview =nil;
                }
                recordpath = nil;
                recorduuid = nil;
                [table beginUpdates];
                [table reloadData];
                [table endUpdates];
            }
            break;
    }
}







//开始录音
-(void)clickRecord
{
    
    if (effectview)
        return;
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
 
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 120);
    [self.view addSubview:effectview];
    
    NSArray *arry = [[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:nil options:nil];
    ezview = arry[0];
    ezview.frame = CGRectMake(0, 0, effectview.frame.size.width, effectview.frame.size.height);
    ezview.delegate=self;
    [effectview addSubview:ezview];
    
    [UIView animateWithDuration:0.2 animations:^{
        effectview.transform = CGAffineTransformMakeTranslation(0, -120);
    }];
}



#pragma mark RecordDelegate
-(void)RecordFinish:(NSString *)uuid filepath:(NSString *)filepath
{
   NSLog(@"录音完成 uuid %@ 文件地址 %@",uuid,filepath);
    
    recorduuid=[uuid copy];
    recordpath = [filepath copy];
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
    
    [table reloadData];
    if (audioview)
        [ audioview viewResume];
}




-(void)RecordCancel
{
    NSLog(@"录音取消");
    if (audioview)
        [ audioview viewResume];
}



#pragma mark picture
-(void)showSheet
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
    if(audioview)
        [ audioview playStop];
    
    
    __weak __typeof(self) weakself = self;
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"selectpicturetitle", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:NSLocalizedString(@"picturebtn1", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself ClickMore:1];
        
    }];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:NSLocalizedString(@"picturebtn2", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself ClickMore:2];
    }];
    UIAlertAction *action3=[UIAlertAction actionWithTitle:NSLocalizedString(@"btncancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
}



//更多
-(void)ClickMore:(int)moretype
{
    switch (moretype) {
        case 1:
            
            pickerview = [[UIImagePickerController alloc] init];//初始化
            pickerview.delegate = self;
            pickerview.allowsEditing = YES;//设置可编辑
            pickerview.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerview animated:YES completion:nil];//进入照相界面
            break;
        case  2:
            pickerview = [[UIImagePickerController alloc] init];//初始化
            pickerview.delegate = self;
            pickerview.allowsEditing = YES;//设置可编辑
            pickerview.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerview animated:YES completion:nil];//进入照相界面
            break;
            
    }
    NSLog(@"更多选择 %lu",(unsigned long)moretype);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"SMILE!");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *photo =UIImageJPEGRepresentation(image,0.5);
    NSString *_uuid = [[NSUUID UUID] UUIDString];
    NSString *_filepath = [[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",_uuid]];
    [photo writeToFile:_filepath atomically:YES];
    
    [imgidlist addObject:_filepath];
    
    [table beginUpdates];
    [table reloadData];
    [table endUpdates];
    
    
}


-(void)deletePhoto:(id)sender
{
    UIButton *_btn = (UIButton *)sender;
    int i = _btn.tag;
    [imgidlist removeObjectAtIndex:i];
    [table beginUpdates];
    [table reloadData];
    [table endUpdates];
}


#pragma mark add text
-(void)showInputTextView
{
    [self performSegueWithIdentifier:@"showText" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)FinishInput:(NSString *)txt
{
    remark = [txt copy];
    remarkRect = [remark boundingRectWithSize:CGSizeMake([PublicCommon GetALLScreen].size.width-70, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    remarkcellheight =remarkRect.size.height+20;
    [table beginUpdates];
    [table reloadData];
    [table endUpdates];
}




#pragma mark showsheet
-(void)showSheetForType
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"typealerttitle", nil) message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    

    UIPickerView *pickmark = [[UIPickerView alloc] init];
    imgmarkstr = @"bj";
    selectmarktype = @"bj0";
    pickmark.frame = CGRectMake(8, 50, alert.view.frame.size.width-36 , 200);
    pickmark.delegate=self;
    pickmark.dataSource=self;
    [alert.view addSubview:pickmark];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"btncancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"btnok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [table beginUpdates];
        [table reloadData];
        [table endUpdates];
    }];
    
    [alert addAction:action1];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
        return 14;
    return 7;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (component==0){
        UILabel *labtitle = [[UILabel alloc] init];
        NSString *marktitle = [NSString stringWithFormat:@"mark%d",row];
        labtitle.text=NSLocalizedString(marktitle, nil);
        labtitle.textAlignment = NSTextAlignmentCenter;
        labtitle.font=[UIFont systemFontOfSize:18];
        return labtitle;
    }
    if (component==1){
        UIImageView *img= [[UIImageView alloc] init];
        img.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imgmarkstr,row]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        return img;
    }
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        switch (row) {
            case MARK:
                imgmarkstr = @"bj";
                break;
            case Store:
                imgmarkstr = @"bld";
                break;
            case Restaurant:
                imgmarkstr = @"ct";
                break;
            case BUS:
                imgmarkstr = @"gj";
                break;
            case Beach:
                imgmarkstr = @"ht";
                break;
            case AIRPORT:
                imgmarkstr = @"jc";
                break;
            case Hotel:
                imgmarkstr = @"jd";
                break;
            case GAS:
                imgmarkstr = @"jyz";
                break;
            case Wharf:
                imgmarkstr = @"mt";
                break;
            case Park:
                imgmarkstr = @"p";
                break;
            case Diving:
                imgmarkstr = @"qs";
                break;
            case Hill:
                imgmarkstr = @"s";
                break;
            case Shopping:
                imgmarkstr = @"sc";
                break;
            case Tree:
                imgmarkstr = @"tree";
                break;
        }
        [pickerView reloadComponent:1];
    }
    if (component==1)
    {
        marktype = row;
        selectmarktype =[NSString stringWithFormat:@"%@%d",imgmarkstr,row];
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component==1)
        return 60;
    return 40;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TextViewController *txtmemoview;
    if ([segue.identifier isEqualToString:@"showText"])
    {
        txtmemoview = (TextViewController *)[segue destinationViewController];
        txtmemoview.string = remark;
        txtmemoview.delegate=self;
    }
}

@end
