//
//  HFAnimals.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/12/21.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFAnimals.h"
//static

@interface HFAnimals ()
/*
 @property (nonatomic, copy) NSString *nickName;
 @property (nonatomic, copy) NSString *name;
 //特征，这里使用strong是为了 对比copy
 @property (nonatomic, strong) NSString *characterContent;
 
 @property (nonatomic, assign) HFAnimalType type;

 1、
 // weak修饰age 报错：Property with 'weak' attribute must be of object type
 @property (nonatomic, weak) NSInteger age;


 @property (nonatomic, assign) NSInteger age;
 //查看nonatomic 和 atomic 的区别
 @property (assign) NSInteger otherAge;

 */
@end

@implementation HFAnimals

@dynamic nickName;

@synthesize otherAge = _otherAge;
- (id)init{
    if (self = [super init]) {
        NSLog(@"self = %@",NSStringFromClass([self class]));
        NSLog(@"super = %@",NSStringFromClass([super class]));
        _type = HFAnimalTypeOtherlegs;

    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@" _name = %@ _characterContent = %@ _age = %ld _otherAge = %ld _type = %ld",_name,_characterContent,_age,_otherAge,_type];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    static NSInteger count = 0;
    BOOL superRsolve = [super resolveInstanceMethod:sel];
    count +=1;
    NSLog(@"superR = %d count = %ld",superRsolve,count);
    return superRsolve;
}
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id target = [super forwardingTargetForSelector:aSelector];
    if (!target) {

        return nil;
    }
    NSLog(@"target = %@",target);
    return target;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    NSLog(@"signature = %@",signature);
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"anInvocation = %@",anInvocation);
}

- (void)setAge:(NSInteger)age
{
    NSLog(@"start setter age = %ld currentThread = %@",age,[NSThread currentThread]);

    _age = age;
}


/*
 Writable atomic property 'otherAge' cannot pair a synthesized getter with a user defined setter
 Setter and getter must both be synthesized, or both be user defined,or the property must be nonatomic
 
 当属性关键字是 atomic的时候，如果重写setter和或getter方法，必须同时重写，且需要使用@synthesize关键字指定属性的setter的实例变量名
 
 @synchronized(self)或者lock锁机制只允许原子性访问
 @synchronized 表示这个方法加锁m，相当于不管哪一个线程（A），运行到这个方法时，都要检查有没有其他线程（B）正在使用这个方法，有的话j要等正在使用synchronized的方法的线程B运行完这个方法再运行方法A，没有B的话就直接运行A。
 */
- (void)setOtherAge:(NSInteger)otherAge{
    
    NSLog(@"start setter otherAge = %ld currentThread = %@",otherAge,[NSThread currentThread]);
    @synchronized (self) {
        sleep(3);
        _otherAge = otherAge;
        NSLog(@" ing currentThread = %@",[NSThread currentThread]);
    }
    NSLog(@"end setter otherAge = %ld currentThread = %@",otherAge,[NSThread currentThread]);

}
- (NSInteger)otherAge
{
    NSLog(@"start getter otherAge = %ld",_otherAge);

    @synchronized (self) {
        NSLog(@" ing currentThread = %@",[NSThread currentThread]);
        return _otherAge;
    }
    NSLog(@"end getter otherAge = %ld",_otherAge);

}












@end
