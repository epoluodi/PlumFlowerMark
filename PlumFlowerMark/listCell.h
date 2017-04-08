//
//  listCell.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/4/7.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface listCell : UITableViewCell
{
    UILabel *_labcoordinate;
    UIImageView *_jpgimg,*_recordimg;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleright;
@property (weak, nonatomic) IBOutlet UIImageView *mapimg;
@property (weak, nonatomic) IBOutlet UIImageView *markimg;
@property (weak, nonatomic) IBOutlet UILabel *title;

-(void)loadDataPlaceInfo:(id)placeinfo;
@end
