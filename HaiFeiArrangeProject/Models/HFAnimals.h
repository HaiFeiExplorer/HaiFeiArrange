//
//  HFAnimals.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/12/21.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HFAnimalType)
{
    
    HFAnimalTypeTwolegs = 2, //二
    HFAnimalTypeThreelegs, //三
    HFAnimalTypeFourlegs, //四肢
    HFAnimalTypeOtherlegs,//其他种类
    
};

//自定义的对象 --目的：验证属性关键字
@interface HFAnimals : NSObject

//@dynamic 用关键字，看执行器setter或getter方法会如何
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *name;
//特征，这里使用strong是为了 对比copy
@property (nonatomic, strong) NSString *characterContent;

@property (nonatomic, assign) HFAnimalType type;
/*
 1、
 // weak修饰NSInteger类型 报错：Property with 'weak' attribute must be of object type
 @property (nonatomic, weak) NSInteger age;
 */
@property (nonatomic, assign) NSInteger age;

//查看nonatomic 和 atomic 的区别,y后者是保证在执行setter和getter方法的时候线程安全，出了这两个方法之外的线程安全是不负责的
@property (assign) NSInteger otherAge;


@end

NS_ASSUME_NONNULL_END
