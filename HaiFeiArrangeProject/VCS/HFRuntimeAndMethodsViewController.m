//
//  HFRuntimeAndMethodsViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/14.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFRuntimeAndMethodsViewController.h"
#import "HFFatherModel.h"

@interface HFRuntimeAndMethodsViewController ()

@end

@implementation HFRuntimeAndMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [HFFatherModel testObjc_msgSend];
    [self msgMethodForRunTimeExchang];
    [self equalPamrsDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)msgMethodForRunTimeExchang
{
    //    NSString *myMethodSwappString = @"Good Study For Job";
    //    [myMethodSwappString lowercaseString];
    //    [myMethodSwappString performSelector:@selector(doSomethingForRun)];
    
    HFFatherModel *fatherModel = [HFFatherModel new];
    fatherModel.firstParms = @"First";
    fatherModel.secondParms = @"Second";
    
    [fatherModel replaceMethodsAction];
    
    [fatherModel classMethodName];
    [fatherModel exchangeMethodA];
    [fatherModel exchangeMethodB];
    NSLog(@"开始rntime相关的操作----");
    [fatherModel runtimeTest];
    
    NSLog(@"rntime之后 相关的操作----");
    
    [fatherModel performSelector:@selector(addNewMethod)];
    
    [fatherModel classMethodName];
    NSLog(@"--classMethodName-- 被替换为replaceMethodsAction");
    
    
    [fatherModel replaceMethodsAction];
    
    
    [fatherModel exchangeMethodA];
    NSLog(@"--exchangeMethodA-- 执行 为方法B");
    
    [fatherModel exchangeMethodB];
    NSLog(@"--exchangeMethodB-- 执行 为方法A");
    
    
    
    
}
- (void)factoryArrayDetail
{
    //    HFFactoryArray *array = [HFFactoryArray arrayWithObject:@1];
    //    NSLog(@"array  =%@",array);
}
#pragma mark -
//关于‘对象等同性的理解’
- (void)equalPamrsDetail
{
    NSString *foo = @"Foo 123";
    NSString *bar = [NSString stringWithFormat:@"Foo %i",123];
    NSLog(@"foo 地址 = %p,bar 地址 = %p",&foo,&bar);
    //foo 地址 = 0x7fff5a835758,bar 地址 = 0x7fff5a835750
    NSString *tempStr = foo;
    NSLog(@"tempStr 地址 = %p",&tempStr);
    // tempStr 地址 = 0x7fff5a835748
    NSString *foo123 = @"Foo 123";
    NSString *bar123 = [NSString stringWithFormat:@"Foo %i",123];
    NSLog(@"foo123 地址 = %p,bar123 地址 = %p",&foo123,&bar123);
    //foo123 地址 = 0x7fff5a835740,bar123 地址 = 0x7fff5a835738
    /*
     1、== 对比的是两个指针
     2、isEqual 对比的是两个对象的等同性，一般来说，两个类型不同的对象总是不相等的
     3、isEqualToString是NSString实现的一个自己独有的等同性判断的方法，这个方法比isEqual快，原因是它不知道受测对象的类型
     4、isEqulaToArray：NSArray特殊的判断等同性的判断方法
     5、isEqualToDictionary：NSDictionary特殊的判断等同性的判断方法
     等同性判定的执行深度
     NSArray的检测方式为先看两个数组所包含的对象是否相同，若相同，则再在每个对应的位置的两个对象上调用气“isEqual”方法，如果对应位置上的对象均相等，那么这两个数组就相等，这叫做“深度等同性判定”，不过有的时候不需要将所有数据注意比较，只根据其中部分数据即可判断是否相同！例如：自定义的类中的ID之类的属性
     注意：把某个对象加入set之后又修改其内容，之后的行为将会难以预料，如果要这么做，需要注意其隐患，可查看关于mutSetOne的实验打印
     */
    BOOL equalA = (foo == bar);
    BOOL equalB = [foo isEqual:bar];
    BOOL equalC = [foo isEqualToString:bar];
    
    
    NSLog(@"equalA= %d,equalB= %d,equalC= %d",equalA,equalB,equalC);
    // equalA= 0,equalB= 1,equalC= 1
    
    HFFatherModel *fatherOne = [[HFFatherModel alloc]initWithFirstParms:@"First" secondParms:@"second"];
    HFFatherModel *fatherTwo = [[HFFatherModel alloc]initWithFirstParms:@"First" secondParms:@"second"];
    
    NSLog(@"[fatherOne isEqual:fatherTwo] = %d",[fatherOne isEqual:fatherTwo]);
    
    NSMutableArray *mutArray = [NSMutableArray array];
    [mutArray addObject:fatherOne];
    [mutArray addObject:fatherTwo];
    NSLog(@"mutArray = %@",mutArray);
    
    NSMutableSet *mutSet = [NSMutableSet set];
    [mutSet addObject:fatherOne];
    [mutSet addObject:fatherTwo];
    NSLog(@"mutSet = %@",mutSet);
    
    
    NSMutableSet *mutSetOne= [NSMutableSet set];
    NSMutableArray *arrayA = [@[@1,@2]mutableCopy];
    NSMutableArray *arrayB = [@[@1,@2]mutableCopy];
    NSMutableArray *arrayC = [@[@1]mutableCopy];
    
    [mutSetOne addObject:arrayA];
    NSLog(@"添加数组A后-- mutSetOne = %@",mutSetOne);
    [mutSetOne addObject:arrayB];
    NSLog(@"添加数组B后-- mutSetOne = %@",mutSetOne);
    
    [mutSetOne addObject:arrayC];
    NSLog(@"添加数组C后-- mutSetOne = %@",mutSetOne);
    
    [arrayC addObject:@2];
    NSLog(@"修改数组C后-- mutSetOne = %@",mutSetOne);
    
    NSSet *resultSet = [mutSetOne copy];
    NSLog(@"resultSet = %@",resultSet);
    /*
     2018-07-27 16:15:43.427 HaiFeiArrangeProject[42180:19445571] 添加数组A后-- mutSetOne = {(
     (1,2))}
     2018-07-27 16:15:43.428 HaiFeiArrangeProject[42180:19445571] 添加数组B后-- mutSetOne = {(
     (1,2))}
     2018-07-27 16:15:43.428 HaiFeiArrangeProject[42180:19445571] 添加数组C后-- mutSetOne = {(
     (1),(1,2)}
     2018-07-27 16:15:43.428 HaiFeiArrangeProject[42180:19445571] 修改数组C后-- mutSetOne = {(
     (1,2),(1,2))}
     2018-07-27 16:18:28.101 HaiFeiArrangeProject[42216:19446994] resultSet = {(
     (1,2))}
     */
    
}
@end
