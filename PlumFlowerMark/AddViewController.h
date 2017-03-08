//
//  AddViewController.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/6.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AddViewController : BaseViewController
{
    BOOL _firstLocationUpdate;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UITableView *table;




@end
