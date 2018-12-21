//
//  NSString+HFMethodExChange.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/1.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "NSString+HFMethodExChange.h"
#import <objc/message.h>

@implementation NSString (HFMethodExChange)

/*
 load方法：把类加载进内存的时候调用，只会调用一次，方法可以先交换，再去交换
 */
+ (void)load
{
    Method orignialMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swappedMethods = class_getInstanceMethod([NSString class], @selector(hf_lowerStrinf));
    method_exchangeImplementations(orignialMethod, swappedMethods);
}

- (NSString *)hf_lowerStrinf
{
    /*
     这个方法如此调用 似乎会陷入递归的死循环，实际上呢，此方法是准备和lowercaseString方法交换的，所以在运行期间，hf_lowerStrinf方法实现实际上对应的是lowercaseString方法的实现，所以不会出现死循环！
     */
    NSString *lower = [self hf_lowerStrinf];
    lower = [NSString stringWithFormat:@"my lower is ___ = %@",lower];
    NSLog(@"lower = %@",lower);
    return lower;
}


+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"doSomethingForRun"]) {
        //动态添加doSomethingForRun方法
        /*
         class: 给哪个类添加方法
         SEL：添加哪个方法，即添加方法的方法编号
         IMP：方法实现=>函数=>函数入口=>函数名（添加方法的函数实现或者称为函数地址）
         type:方法类型，（返回值+参数类型 v:void @:对象->self :表示SEL->_cmd）
         class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
         const char * _Nullable types)
         type解释：
         ”v@:”意思就是这已是一个void类型的方法，没有参数传入。
         “i@:”就是说这是一个int类型的方法，没有参数传入。
         ”i@:@”就是说这是一个int类型的方法，又一个参数传入
         */
        //class_getMethodImplementation([NSString class],@selector(doSomethingForRunForeHead))
        class_addMethod([NSString class], sel, (IMP)doSthForeHead, "v@:");
        return YES;
        
    }
    return [super resolveInstanceMethod:sel];
}

void doSthForeHead(id self,SEL _cmd){
    NSLog(@"doSthForeHead");
}



- (void)doSomethingForRunForeHead
{
    NSLog(@"doSomethingForRunForeHead");
}
@end
