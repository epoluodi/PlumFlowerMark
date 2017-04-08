//
//  listCell.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/4/7.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "listCell.h"
#import "PlaceInfo+CoreDataClass.h"
#import <Common/FileCommon.h>

@implementation listCell
@synthesize title,titleright;
@synthesize mapimg,markimg;

- (void)awakeFromNib {
    [super awakeFromNib];
    _labcoordinate = [[UILabel alloc] init];
    _jpgimg = [[UIImageView alloc] init];
    _recordimg = [[UIImageView alloc] init];
    
    title.textColor= [UIColor whiteColor];
    mapimg.contentMode = UIViewContentModeScaleAspectFill;
    mapimg.layer.masksToBounds=YES;
    // Initialization code
}

-(void)loadDataPlaceInfo:(id)placeinfo
{
    NSString *filepath;
    PlaceInfo *_placeinfo = (PlaceInfo *)placeinfo;
    if ([_placeinfo.imgs isEqualToString:@"0"])
    {
        filepath = [[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",_placeinfo.mapimg]];

    }
    else
    {
        NSArray *imgarry = [_placeinfo.imgs componentsSeparatedByString:@","];
        filepath = [[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imgarry[0]]];
    }
    
    UIImage *_img = [UIImage imageWithContentsOfFile:filepath];
    mapimg.image = _img;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
