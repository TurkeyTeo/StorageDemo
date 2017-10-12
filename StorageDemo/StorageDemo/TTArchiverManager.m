//
//  TTArchiverManager.m
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTArchiverManager.h"

#define Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define ArchiverFile    [Document stringByAppendingPathComponent:@"Archiver"]

@interface TTArchiverManager()
@property(nonatomic, strong) NSFileManager *fileManager;
@end

@implementation TTArchiverManager


/**
 单例
 
 @return TTArchiverManager
 */
+ (TTArchiverManager *)shareManager{
    static TTArchiverManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTArchiverManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if ([super init]) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

/**
 清除本地序列化文件
 */
- (void)clearArchiverData{
    NSError *error;
    if ([self.fileManager removeItemAtPath:ArchiverFile error:&error]) {
        
    }else{
        NSLog(@"清除本地序列化失败");
    }
}


/**
 保存缓存数据
 
 @param obj obj
 @param key key
 */
- (void)saveArchiverData:(id)obj key:(NSString *)key{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];
    [self createArchiverFile];
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *path = [ArchiverFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.text",key]];
    BOOL isSuc = [data writeToFile:path atomically:YES];
    if(!isSuc) {
        NSLog(@"本地序列化失败key....:%@",key);
    }
}

// 创建文件
- (void)createArchiverFile{
    if (![self checkPathIsExist:ArchiverFile]) {
        [self.fileManager createDirectoryAtPath:ArchiverFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

// 检测path路径文件是否存在
- (BOOL)checkPathIsExist:(NSString *)path
{
    return [self.fileManager fileExistsAtPath:path isDirectory:nil];
}



/**
 根据key查询数据
 
 @param key key
 @return data
 */
- (id)queryData:(NSString *)key{
    NSString *str = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *path = [ArchiverFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.text",str]];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id content = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    NSLog(@"content.....:%@",content);
    return content;
}

@end
