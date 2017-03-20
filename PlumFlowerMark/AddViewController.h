//
//  AddViewController.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/6.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "EZRecordView.h"
#import "EZAudioView.h"
#import "TextViewController.h"

@interface AddViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate,RecordDelegate,UIImagePickerControllerDelegate,TextViewInputDelegate>
{
    BOOL _firstLocationUpdate;
    NSString *locaddress,*lnglat,*altitude,*angleStr;
  
    NSMutableArray<NSString *>* imgidlist;
    NSString *recordpath,*recorduuid,*remark;
    
    UILabel *labaddr,*lablnglat,*labaltitude,*labangleStr,*labremark;
    
    
    //recordview
    UIVisualEffectView *effectview ;
    EZRecordView *ezview;
    
    EZAudioView *audioview;
    EZAudioFile *audiofile;
    EZAudioPlot *audioplot;
    
    int remarkcellheight;
    CGRect remarkRect ;
    
    //图片
    UIImagePickerController *pickerview;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UITableView *table;




@end
