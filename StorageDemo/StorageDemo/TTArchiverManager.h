//
//  TTArchiverManager.h
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTArchiverManager : NSObject


/**
 单例

 @return TTArchiverManager
 */
+ (TTArchiverManager *)shareManager;


/**
 清除本地序列化文件
 */
- (void)clearArchiverData;


/**
 保存缓存数据

 @param obj obj
 @param key key
 */
- (void)saveArchiverData:(id)obj key:(NSString *)key;


/**
 根据key查询数据

 @param key key
 @return data
 */
- (id)queryData:(NSString *)key;

@end
