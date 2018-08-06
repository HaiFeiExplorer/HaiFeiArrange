//
//  HFFatherModel.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFFatherModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface HFFatherModel()
//@property (nonatomic, copy) NSString *tempStr;
{
    NSString *_fatherAge;
    NSString *_fatherRole;
    NSInteger _fatherNum;
}
@end

@implementation HFFatherModel


- (id)initWithFirstParms:(NSString *)firstStr secondParms:(NSString *)secondStr
{
    if (self = [super init]) {
        _firstParms = firstStr;
        _secondParms = secondStr;
    }
    return self;
}
- (NSUInteger)hash{
    //这个方法在校验对象唯一的时候 才会执行，
    //1、一般而言就是执行isEqual的时候才会触发这个方法
    //2、将对象加入到set或者是字典的key的时候也会执行（set和字典的key是需要校验唯一性）
    //如下返回hash是一种相对可以保持高效，又能使生成的哈希码在一定范围内不会过于频繁地重复
    //编写hash方法时，应该用当前的对象做实验，以便在减少碰撞频度与降低运算复杂程序之间的取舍
    NSUInteger hash = [self.firstParms hash] ^ [self.secondParms hash];
    NSLog(@"hsah = %ld",hash);
    return hash;
}

- (BOOL)isEqual:(id)object
{
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HFFatherModel class]]) {
        return NO;
    }
    
    return [self isEqualToFatherModel:(HFFatherModel *)object];
    
}

- (BOOL)isEqualToFatherModel:(HFFatherModel *)father
{
    if (!father) {
        return NO;
    }
    
    BOOL haveEqualNames = (!self.firstParms && !father.firstParms) || [self.firstParms isEqualToString:father.firstParms];
    BOOL haveEqualBirthdays = (!self.secondParms && !father.secondParms) || [self.secondParms isEqualToString:father.secondParms];
    
    return haveEqualNames && haveEqualBirthdays;
    

}
- (void)runtimeTest
{
    /*
     常见方法
     
     */
    //1、获取属性列表
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSLog(@"属性数目propertyCount = %d",count);

    for (unsigned int i = 0; i < count; i++) {
        //获得属性名
        const char *properName = property_getName(propertyList[i]);
        NSLog(@"property -- > name = %@",[NSString stringWithUTF8String:properName]);
    }
    
   //2、获取方法列表
    Method  *methodList = class_copyMethodList([self class], &count);
    NSLog(@"方法数目 methodListCount  = %d",count);

    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method name = %@",NSStringFromSelector(method_getName(method)));
        
    }
    //3、获得成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    NSLog(@"实力变量数目 methodListCount  = %d",count);

    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        //获得实力变量名称
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"实力变量 Ivar name = %@",[NSString stringWithUTF8String:ivarName]);
    }
    //4、获取协议列表
    __unsafe_unretained Protocol **protocoList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i< count; i++) {
        Protocol *tempProtocol = protocoList[i];
        //获得协议名称
        const char *tempProtocolName = protocol_getName(tempProtocol);
        NSLog(@"协议名称 -- protocoName = %@",[NSString stringWithUTF8String:tempProtocolName]);
    }
    //5、获得实例方法
    Method  myInstanceMethod = class_getInstanceMethod([self class], @selector(classMethodName));
    NSLog(@"myInstanceMethod name = %@",NSStringFromSelector(method_getName(myInstanceMethod)));

    //6、获得类方法
    
    Method  myClassMethod = class_getClassMethod([self class], @selector(testObjc_msgSend));
    NSLog(@"myClassMethod name = %@",NSStringFromSelector(method_getName(myClassMethod)));

    
    //7、添加方法
    /*
     
     */
//    新增addNewMethod方法 其实现是addNewtempMethods方法的实现
    Method  addNewtempMethods = class_getInstanceMethod([self class], @selector(addNewtempMethods));

    class_addMethod([self class], @selector(addNewMethod), method_getImplementation(addNewtempMethods), method_getTypeEncoding(addNewtempMethods));
    //8、替换方法
    
    Method replaceMethod = class_getInstanceMethod([self class], @selector(replaceMethodsAction));
    //myInstanceMethod
    //这样子设置的意思是classMethodName的实现替换了replaceMethodsAction 的实现
//    class_replaceMethod([self class], @selector(replaceMethodsAction), method_getImplementation(myInstanceMethod), method_getTypeEncoding(myInstanceMethod));
    
    //如下是是用方法replaceMethodsAction的实现 替换方法classMethodName的
    /*
     class: 给哪个类添加方法
     SEL：被替换的方法，即该方法的方法编号
     IMP：（将来要使用替换成的方法实现）方法实现=>函数=>函数入口=>函数名（添加方法的函数实现或者称为函数地址）
     
     imp可以用method_getImplementation方法获得
    
     type:（要替换成的方法的方法类型）方法类型，（返回值+参数类型 v:void @:对象->self :表示SEL->_cmd）
     type的相关可以用method_getTypeEncoding方法获取
    
     
     class_replaceMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
     const char * _Nullable types)
     
     
     */
    class_replaceMethod([self class], @selector(classMethodName), method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));

    //9、交换方法
    //A和B的方法交换
    Method exchangeMethodA = class_getInstanceMethod([self class], @selector(exchangeMethodA));
    Method exchangeMethodB = class_getInstanceMethod([self class], @selector(exchangeMethodB));
    method_exchangeImplementations(exchangeMethodA, exchangeMethodB);
    
    //以上是比较常见的几个关于runtime的方法，其他的方法还可以查看runtime的开发文档！
    
    
    


}
-(void)classMethodName
{
    NSLog(@"classMethodName 具体实现");
//    NSLog(@" ----原始的---- = %@",NSStringFromSelector(_cmd));
    
}

- (void)addNewtempMethods
{
    NSLog(@"新增的方法 ---- = %@",NSStringFromSelector(_cmd));

}
//
- (void)replaceMethodsAction
{
    NSLog(@"replaceMethodsAction 具体实现");
//    NSLog(@"----交换的 ---- = %@",NSStringFromSelector(_cmd));

}

- (void)exchangeMethodA
{
    NSLog(@" -A--- = %@",NSStringFromSelector(_cmd));

}
- (void)exchangeMethodB
{
    NSLog(@" -B--- = %@",NSStringFromSelector(_cmd));

}
+ (void)testObjc_msgSend
{
    SEL testFunc = NSSelectorFromString(@"testFunc");
    
    ((void (*) (id, SEL)) (void *)objc_msgSend)([HFFatherModel new], testFunc);
}
- (void)testFunc
{

    NSLog(@"123123");
}

@end
