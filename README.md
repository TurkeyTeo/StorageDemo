# StorageDemo
##1. Core Data
###1. 简介

Core Data是一种基于SQLite的可视化数据持久化解决方案。它允许按照`实体`-`属性`-`值模型`组织数据，并且支持XML文件、二进制文件、SQLite数据文件操作。

Core Data还能对非法数据进行过滤，还支持对数据操作的Undo/Redo功能。更重要的是，Core Data的`NSFetchRequest`类可以替代SQL中的Select语句。



### 2. 结构

- **NSPersistentContainer(持久化容器)**：`NSPersistentContainer` 将之前的`NSManagedObjectContext`，`NSManagedObjectModel`， `NSPersistentStoreCoordinator` 整合在了一起，它简化创建一个新的CoreData堆。并且维持你项目中的`NSManagedObjectModel` ，`NSPersistentStoreCoordinator` 和其他资源的引用。

![NSPersistentContainer.png](http://upload-images.jianshu.io/upload_images/3261360-71c26fb6468fc08b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- **NSManagedObjectContext(数据上下文)**：

  - 对象管理上下文，负责数据的实际操作(重要)
  - 作用：插入数据，查询数据，删除数据，更新数据

- **NSManagedObjectModel(数据模型)**：

  - 数据库所有表格或数据结构，包含各实体的定义信息
  - 作用：添加实体的属性，建立属性之间的关系
  - 操作方法：视图编辑器，或代码

- **NSPersistentStoreCoordinator(持久化存储助理)**

  - 相当于数据库的连接器
  - 作用：设置数据存储的名字，位置，存储方式，和存储时机。负责从磁盘加载数据和将数据写入磁盘。协调器可以处理多种格式的数据库文件（NSPersistentStore），如二进制文件，XML文件、SQLite文件。

  ​

- **NSManagedObject(被管理的数据记录)**

  - 数据库中的表格记录。Core Data的核心单元。模型对象的数据被持有在NSManagedObject对象中。每一个NSManagedObject对象都对应一个实体（就像每一个对象都有一个类）

- **NSEntityDescription(实体结构)**

  - 相当于表格结构。实体可以被看做是NSManagedObject对象的“class”。实体定义了一个NSManagedObject对象所拥有的所有属性（NSAttributeDescription）,关系（NSRelationshipDescription），提取属性（NSFetchedPropertyDescription）。

- **NSFetchRequest(数据请求)**

  - 相当于查询语句

- **后缀为.xcdatamodeld的包**

  - 里面是.xcdatamodel文件，用数据模型编辑器编辑
  - 编译后为.momd或.mom文件



### 3. 创建

```objective-c
1.创建模型文件 ［相当于一个数据库］
2.添加实体 ［一张表］
3.创建实体类 [相当模型--表结构]
4.生成上下文 关联模型文件生成数据库
```

这里不说具体的操作，直接看看代码如何实现增删改查。（注意：添加NSManagedObject Subclass 需要选中.xcdatamodeld文件，选中Editor->Create NSManagedObject Subclass。如下图）


![createNSM.png](http://upload-images.jianshu.io/upload_images/3261360-6d144c8974f3dbef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当我们创建工程勾选了`Use Core Data`，假设我们创建的实体如图：


![xcdatamodeld.png](http://upload-images.jianshu.io/upload_images/3261360-58fada6b1193a824.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
可以在AppDelegate.m中看到：

```objective-c
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"StorageDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
```



#### 3.1 增

```objective-c
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
```



#### 3.2 删

```objective-c
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
```



#### 3.3 改

```objective-c
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
```



#### 3.4 查

```objective-c
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
```



另：我们在创建该对象时，不能直接[XXX alloc] init]，需要调用`insertIntoManagedObjectContext`：

```objective-c
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
```

##2.Archiver
```
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
    
    
