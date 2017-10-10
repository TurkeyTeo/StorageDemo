//
//  TTCoreDataManager.h
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+CoreDataProperties.h"

@interface TTCoreDataManager : NSObject

+ (TTCoreDataManager *)shareInstance;


/**
 增加用户

 @param user user
 */
- (void)addUser:(User *)user;


/**
 根据userID删除用户

 @param userID userID
 */
- (void)deleteUser:(NSInteger)userID;


/**
 修改用户

 @param user user
 */
- (void)modifyUser:(User *)user;



/**
 根据userID查询用户


 @param userID userID
 @return userArray
 */
- (NSArray *)queryUser:(NSInteger)userID;

@end
