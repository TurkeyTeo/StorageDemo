//
//  AppDelegate.h
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

