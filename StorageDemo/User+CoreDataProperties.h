//
//  User+CoreDataProperties.h
//  StorageDemo
//
//  Created by Thinkive on 2017/10/10.
//  Copyright © 2017年 Teo. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userName;
@property (nonatomic) int16_t userAge;
@property (nonatomic) int32_t userID;
@property (nullable, nonatomic, copy) NSString *userGender;

@end

NS_ASSUME_NONNULL_END
