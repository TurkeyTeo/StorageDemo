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
#import "TTArchiverManager.h"


// 如果想将一个自定义对象保存到文件中必须实现NSCoding协议
@interface Person : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

@implementation Person

// 当将一个自定义对象保存到文件的时候就会调用该方法
// 在该方法中说明如何存储自定义对象的属性
// 也就是说在该方法中说清楚存储自定义对象的哪些属性
- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

// 当从文件中读取一个对象的时候就会调用该方法
// 在该方法中说明如何读取保存在文件中的对象
// 也就是说在该方法中说清楚怎么读取文件中的对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.age=[aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}
@end



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self handleCoreData];
    [self handleArchiver];
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



/**
 Archiver
 */
- (void)handleArchiver{
    //   一.使用archiveRootObject进行简单的归档。
    //    可以对字符串、数字等进行归档，当然也可以对NSArray与NSDictionary进行归档。返回值Flag标志着是否归档成功，YES为成功，NO为失败。
    
    //    归档
    //    1.获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.添加存储的文件名
    NSString *path = [docPath stringByAppendingPathComponent:@"data.archiver"];
    //3.将一个对象保存到文件中
    BOOL flag = [NSKeyedArchiver archiveRootObject:@"Turkey" toFile:path];
    NSLog(@"%d",flag);
    
    
    //    解档
    //    1.获取文件路径
    NSLog(@"path=%@",path);
    //    2.从文件中读取对象
    id name = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",name);
    
    
    //    *************************************************
    
    
    //    二.对多个对象进行归档。（基本类型）
    //    1.归档：使用encodeObject
    NSString *myName = @"Teo";
    NSInteger age = 26;
    NSString *multiPath = [docPath stringByAppendingPathComponent:@"multi.archiver"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *multiArchvier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [multiArchvier encodeObject:myName forKey:@"name"];
    [multiArchvier encodeInteger:age forKey:@"age"];
    [multiArchvier finishEncoding];
    [data writeToFile:multiPath atomically:YES];
    
    //    解档：从路径中获得数据构造NSKeyedUnarchiver实例，使用encodeObject: forKey:方法获得文件中的对象。
    NSMutableData *dataR = [[NSMutableData alloc] initWithContentsOfFile:multiPath];
    NSKeyedUnarchiver *multiUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataR];
    NSString *unName = [multiUnarchiver decodeObjectForKey:@"name"];
    NSInteger unAge = [multiUnarchiver decodeIntegerForKey:@"age"];
    [multiUnarchiver finishDecoding];
    NSLog(@"解档多个对象：%@ %ld",unName,unAge);
    
    
    
    //    *************************************************
    
    
    //    三.对自定义对象进行归档
    //    归档
    //1.创建对象
    Person *person = [[Person alloc] init];
    person.name = @"turkey";
    person.age = 108;
    
    //2.获取文件路径
    NSString *personPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cusPath = [personPath stringByAppendingPathComponent:@"person.archiver"];
    
    //3.将自定义的对象保存到文件中，调用NSKeyedArchiver的工厂方法 archiveRootObject: toFile: 方法
    [NSKeyedArchiver archiveRootObject:person toFile:cusPath];
    
    
    //    解档
    //1.获取文件路径
    //2.从文件中读取对象，解档对象就调用NSKeyedUnarchiver的一个工厂方法 unarchiveObjectWithFile: 即可。
    Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:cusPath];
    NSLog(@"对象解档%@  %ld",p.name,p.age);
    
    
    //    *************************************************
    //    四.封装
    Person *xiaoM = [Person new];
    xiaoM.name = @"xiaoming";
    xiaoM.age = 18;
    
    [[TTArchiverManager shareManager] saveArchiverData:xiaoM key:@"XIAO"];
    [[TTArchiverManager shareManager] queryData:@"XIAO"];
}


@end
