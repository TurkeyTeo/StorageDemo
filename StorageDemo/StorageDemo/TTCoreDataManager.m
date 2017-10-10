//
//  TTCoreDataManager.m
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTCoreDataManager.h"
#import "AppDelegate.h"

@implementation TTCoreDataManager

+ (TTCoreDataManager *)shareInstance{
    static TTCoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TTCoreDataManager alloc] init];
    });
    return instance;
}

/**
 增加用户
 
 @param user user
 */
- (void)addUser:(User *)user{
//    获取上下文对象
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegete.persistentContainer.viewContext;
    User *u = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    u.userID = user.userID;
    u.userName = user.userName;
    u.userAge = user.userAge;
    u.userGender = user.userGender;
//    保存
    [context save:nil];
}

/**
 删除用户
 
 @param userID userID
 */
- (void)deleteUser:(NSInteger)userID{
    //获取应用程序代理以及上下文对象
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegete.persistentContainer.viewContext;
    //创建提取器
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID=%ld",userID]];
    request.predicate = predicate;
    //查询
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    //遍历查询结果并删除
    if (array && array.count > 0) {
        for (User *user in array) {
            [context deleteObject:user];
        }
    }
    [delegete saveContext];
}


/**
 修改用户
 
 @param user user
 */
- (void)modifyUser:(User *)user{
    //获取应用程序代理以及上下文对象
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegete.persistentContainer.viewContext;
    //创建提取器
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID=%d",user.userID]];
    request.predicate = predicate;
    //查询
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (User *u in array) {
        u.userName = user.userName;
        u.userAge = user.userAge;
        u.userGender = user.userGender;
    }
    [context save:nil];
}


/**
 根据userID查询用户
 
 
 @param userID userID
 @return userArray
 */
- (NSArray *)queryUser:(NSInteger)userID{
    //获取应用程序代理以及上下文对象
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegete.persistentContainer.viewContext;
    //创建提取器
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID=%ld",userID]];
    request.predicate = predicate;
    //查询
    NSArray *array = [context executeFetchRequest:request error:nil];
    return array;
}



@end
