//
//  DBmanger.m
//  DyingWish
//
//  Created by xiaoguang yang on 15-4-2.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

#import "DBmanger.h"
#import <Common/FileCommon.h>





@implementation DBmanger


static DBmanger *_db;


+(instancetype)getIntance
{
    if (!_db)
        _db = [[DBmanger alloc] initDB];
    return _db;
}

-(instancetype)initDB
{
    
    self = [super init];
    
    mangedcontext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    mangedcontext.persistentStoreCoordinator = [self persistentstorecoordinator];
    
    return self;
}

-(NSPersistentStoreCoordinator*)persistentstorecoordinator
{
    NSString * modelpath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"momd"];
    mangedobjectmodel = [[NSManagedObjectModel alloc]initWithContentsOfURL:[NSURL fileURLWithPath:modelpath]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mangedobjectmodel];
    NSString *docs = [FileCommon getCacheDirectory];
    
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Main.db"]];//要存得数据文件名
    
    
    
    NSError *error = nil;
    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        
        
        
        return nil;
    }
    return persistentStoreCoordinator;
    
}

-(void)Save
{
    [mangedcontext save:nil];
}

-(PlaceInfo *)getNewPlaceInfo
{
    PlaceInfo * _placeinfo = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceInfo" inManagedObjectContext:mangedcontext];
    return _placeinfo;
}


-(NSArray *)getPlaceInfoArry
{
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"PlaceInfo"];
    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
    return arr;
    
}
@end

