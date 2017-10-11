//
//  ViewController.m
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "ViewController.h"
#import "TTCoreDataManager.h"
#import "User+CoreDataProperties.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self handleCoreData];
}


/**
 core Data
 */
- (void)handleCoreData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:delegate.persistentContainer.viewContext];
    User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:delegate.persistentContainer.viewContext];
    user.userID = 1001;
    user.userName = @"张三";
    user.userGender = @"男";
    user.userAge = 18;
//    插入
    [[TTCoreDataManager shareInstance] addUser:user];
    
//    查询
    NSArray *array = [[TTCoreDataManager shareInstance] queryUser:1001];
    User *zhang = array[0];
    NSLog(@"%@",zhang);
    
    user.userName = @"张小花";
    user.userGender = @"女";
//    修改
    [[TTCoreDataManager shareInstance] modifyUser:user];
    
//    查询
    NSArray *array2 = [[TTCoreDataManager shareInstance] queryUser:1001];
    User *xiaoXH = array2[0];
    NSLog(@"%@",xiaoXH);
    
//    删除
    [[TTCoreDataManager shareInstance] deleteUser:1001];
    
    NSArray *array3 = [[TTCoreDataManager shareInstance] queryUser:1001];
    NSLog(@"%lu",(unsigned long)array3.count);
}




@end
