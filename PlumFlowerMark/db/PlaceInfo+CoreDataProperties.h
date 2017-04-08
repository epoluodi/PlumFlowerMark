//
//  PlaceInfo+CoreDataProperties.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/4/7.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "PlaceInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlaceInfo (CoreDataProperties)

+ (NSFetchRequest<PlaceInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addr;
@property (nullable, nonatomic, copy) NSDate *dt;
@property (nonatomic) double fx;
@property (nonatomic) int32_t groupid;
@property (nonatomic) double hb;
@property (nullable, nonatomic, copy) NSString *imgs;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nullable, nonatomic, copy) NSString *mapimg;
@property (nonatomic) int16_t marktype;
@property (nullable, nonatomic, copy) NSString *marktypeimg;
@property (nullable, nonatomic, copy) NSString *recordfile;
@property (nullable, nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
