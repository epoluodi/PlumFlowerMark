//
//  PlaceInfo+CoreDataProperties.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/4/7.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "PlaceInfo+CoreDataProperties.h"

@implementation PlaceInfo (CoreDataProperties)

+ (NSFetchRequest<PlaceInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PlaceInfo"];
}

@dynamic addr;
@dynamic dt;
@dynamic fx;
@dynamic groupid;
@dynamic hb;
@dynamic imgs;
@dynamic lat;
@dynamic lng;
@dynamic mapimg;
@dynamic marktype;
@dynamic marktypeimg;
@dynamic recordfile;
@dynamic remark;

@end
