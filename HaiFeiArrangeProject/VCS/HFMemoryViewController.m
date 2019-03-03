//
//  HFMemoryViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/12/21.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFMemoryViewController.h"
#import "HFAnimals.h"

@interface HFMemoryViewController ()
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation HFMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"内存管理";
    
    [self imDicCopyAndMutCopy];
    
    NSObject *obj = [[NSObject alloc] init];
    id __weak obj1 = obj;
    
//    [self installSubQueue];
//    [self installSubModels];

}

#pragma mark - Private methods
- (void)installSubModels
{
    HFAnimals *animal = [[HFAnimals alloc]init];
   
    
    animal.nickName = @"nickLisa";
//    NSLog(@"animalNickName = %@",animal.nickName);
    NSMutableString *tempName = [NSMutableString stringWithFormat:@"tempLisa"];
    animal.name = tempName;
    animal.characterContent = tempName;
    NSLog(@"tempName = %p animal.name = %p animal.characterContent = %p",tempName,animal.name,animal.characterContent);

    /*
     如果tempName 是不可变类型的字符串，将它的值赋给name或characterContent，实现的结果一样
     如果tempName 是可变类型的字符串，将它的值赋给name或characterContent，然后修改tempName，那么
     name和characterContent的结果将不一样
     注意：
     1、tempName 如果是往上拼接字符串，那么characterContent的值会是tempName的最新x值
     [tempName appendString:@"add"];
     function:-[HFMemoryViewController installSubModels] line:38 animal.name = tempLisa,charaterContent = tempLisaadd
     tempName的地址不变，内容发生变化，因为characterContent也是指向这块地址所以值也随着变化
     2、如果重新设置tempName，eg：
     tempName = [NSMutableString stringWithFormat:@"changeLisa"];
     function:-[HFMemoryViewController installSubModels] line:49 animal.name = tempLisa,charaterContent = tempLisa
     那么name和characterContent 还是之前的值
     重现设置，表示tempName重新开辟了一块地址存储它的内容，characterContent 还是指向之前的那块地址，所以保持不变
     
     [tempName appendString:@"add"];
     
     tempName = [NSMutableString  stringWithFormat:@"changeLisa"];
     NSLog(@"tempName = %p animal.name = %p animal.characterContent = %p",tempName,animal.name,animal.characterContent);
     NSLog(@"animal.name = %@,charaterContent = %@",animal.name,animal.characterContent);
     
     */
 
 /*
  //关于原子性的测试
  dispatch_async(self.concurrentQueue, ^{
  
  NSLog(@" 1--1---1--  currentThread = %@",[NSThread currentThread]);
  
  animal.age = 5;
  animal.otherAge = 255;
  NSLog(@"1--1---1--animal.description = %@",animal.description);
  
  
  });
  NSLog(@"-------999999---");
  dispatch_async(self.concurrentQueue, ^{
  
  NSLog(@" 2--2---2--  currentThread = %@",[NSThread currentThread]);
  animal.age = 6;
  animal.otherAge = 266;
  NSLog(@"2--2---2--animal.description = %@",animal.description);
  });
  NSLog(@"-------8888---");
  
  dispatch_async(self.concurrentQueue, ^{
  
  NSLog(@" 3--3---3--  currentThread = %@",[NSThread currentThread]);
  animal.age = 7;
  animal.otherAge = 277;
  NSLog(@"3--3---3-- animal.description = %@",animal.description);
  });
  */


 
}



- (void)installSubQueue
{
    //串行队列
    self.serialQueue = dispatch_queue_create("serialQueue.ys.com", DISPATCH_QUEUE_SERIAL);
    //并行队列
    self.concurrentQueue = dispatch_queue_create("concurrentQueue.ys.com", DISPATCH_QUEUE_CONCURRENT);
}


#pragma mark - copy and mutableCopy
/**
 容器类对象 针对字典验证
 */
- (void)imDicCopyAndMutCopy
{
    NSString *immutableStrOne = @"不可变对象1";
    NSMutableString *mutableStrOne = [NSMutableString stringWithFormat:@"可变对象1"];
    NSString *immutableStrTwo = @"不可变对象2";
    NSMutableString *mutableStrTwo = [NSMutableString stringWithFormat:@"可变对象2"];
    /*
     immutableDic.p = 0x6000003d2400 immutableDic.class = __NSDictionaryI
     immutableDic.copy.p = 0x6000003d2400 immutableDic.copy.class = __NSDictionaryI
     immutableDic.mutcopy.p = 0x600002dc8e00,immutableDic.mutcopy.class= __NSDictionaryM
     2019-03-03 12:37:08.098513+0800 MyNewTestDemo[13840:3214742] immutableDic ---key.p = 0x600002398e40,key.class = __NSCFString,key = 可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     2019-03-03 12:37:08.098588+0800 MyNewTestDemo[13840:3214742] immutableDic ---key.p = 0x600002399260,key.class = __NSCFString,key = 可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.098698+0800 MyNewTestDemo[13840:3214742] immutableDic ---key.p = 0x105a20148,key.class = __NSCFConstantString,key = 不可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.098785+0800 MyNewTestDemo[13840:3214742] immutableDic ---key.p = 0x105a20188,key.class = __NSCFConstantString,key = 不可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     2019-03-03 12:37:08.098873+0800 MyNewTestDemo[13840:3214742] immutableDic.copy ---key.p = 0x600002398e40,key.class = __NSCFString,key = 可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     2019-03-03 12:37:08.098950+0800 MyNewTestDemo[13840:3214742] immutableDic.copy ---key.p = 0x600002399260,key.class = __NSCFString,key = 可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.099037+0800 MyNewTestDemo[13840:3214742] immutableDic.copy ---key.p = 0x105a20148,key.class = __NSCFConstantString,key = 不可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.099140+0800 MyNewTestDemo[13840:3214742] immutableDic.copy ---key.p = 0x105a20188,key.class = __NSCFConstantString,key = 不可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     2019-03-03 12:37:08.160496+0800 MyNewTestDemo[13840:3214742] immutableDic.mutcopy ---key.p = 0x105a20188,key.class = __NSCFConstantString,key = 不可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     2019-03-03 12:37:08.160610+0800 MyNewTestDemo[13840:3214742] immutableDic.mutcopy ---key.p = 0x600002399260,key.class = __NSCFString,key = 可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.160716+0800 MyNewTestDemo[13840:3214742] immutableDic.mutcopy ---key.p = 0x105a20148,key.class = __NSCFConstantString,key = 不可变对象1 ,obj.p = 0x105a20148,obj.class = __NSCFConstantString,obj = 不可变对象1
     2019-03-03 12:37:08.160811+0800 MyNewTestDemo[13840:3214742] immutableDic.mutcopy ---key.p = 0x600002398e40,key.class = __NSCFString,key = 可变对象2 ,obj.p = 0x600002398de0,obj.class = __NSCFString,obj = 可变对象1
     
     */
    NSDictionary *immutableDic = @{immutableStrOne:immutableStrOne,immutableStrTwo:mutableStrOne,mutableStrOne:immutableStrOne,mutableStrTwo:mutableStrOne};
    
    NSLog(@"\n immutableDic.p = %p immutableDic.class = %@  \n immutableDic.copy.p = %p immutableDic.copy.class = %@\n immutableDic.mutcopy.p = %p,immutableDic.mutcopy.class= %@",immutableDic,[immutableDic class],[immutableDic copy],[[immutableDic copy] class],[immutableDic mutableCopy],[[immutableDic mutableCopy] class]);
    
    [immutableDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"immutableDic ---key.p = %p,key.class = %@,key = %@ ,obj.p = %p,obj.class = %@,obj = %@ \n",key,[key class],key,obj,[obj class],obj);
        
    }];
    
    [[immutableDic copy] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"immutableDic.copy ---key.p = %p,key.class = %@,key = %@ ,obj.p = %p,obj.class = %@,obj = %@ \n",key,[key class],key,obj,[obj class],obj);
    }];
    
    
    [[immutableDic mutableCopy] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"immutableDic.mutcopy ---key.p = %p,key.class = %@,key = %@ ,obj.p = %p,obj.class = %@,obj = %@ \n",key,[key class],key,obj,[obj class],obj);
        
    }];
    /*
     结论：容器类不可变对象  字典和数组的结论是一致的，且对于字典中的key或value ，都是浅拷贝
     */
}

/**
 容器类可变对象 copy和mutableCopy （本方法是针对数组）
 */
- (void)mutArrayCopyAndMutCopy
{
    NSString *immutableStr = @"不可变对象";
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"可变对象兮"];
    NSMutableArray *mutArray = [NSMutableArray arrayWithObjects:immutableStr,mutableStr, nil];
    
    /*
     mutArray.p = 0x600002c17000 mutArray.class = __NSArrayM
     mutArray.copy.p = 0x60000221ace0 mutArray.copy.Class = __NSArrayI
     mutArray.mutCopy.p = 0x600002c16fd0,mutArray.mutCopy.p= __NSArrayM
     2019-03-03 12:24:00.751299+0800 MyNewTestDemo[13742:3202669] mutArray ---tempStr.p = 0x10ec73088,tempStr = __NSCFConstantString,tempStr.class = 不可变对象
     2019-03-03 12:24:00.751410+0800 MyNewTestDemo[13742:3202669] mutArray ---tempStr.p = 0x600002c17330,tempStr = __NSCFString,tempStr.class = 可变对象兮
     2019-03-03 12:24:00.751502+0800 MyNewTestDemo[13742:3202669] mutArray.copy ---tempCopyStr.p = 0x10ec73088,tempCopyStr = __NSCFConstantString,tempCopyStr.class = 不可变对象
     2019-03-03 12:24:00.751594+0800 MyNewTestDemo[13742:3202669] mutArray.copy ---tempCopyStr.p = 0x600002c17330,tempCopyStr = __NSCFString,tempCopyStr.class = 可变对象兮
     2019-03-03 12:24:00.751694+0800 MyNewTestDemo[13742:3202669] mutArray.mutCopy ---tempMutCopyStr.p = 0x10ec73088,tempMutCopyStr = __NSCFConstantString,tempMutCopyStr.class = 不可变对象
     2019-03-03 12:24:00.751789+0800 MyNewTestDemo[13742:3202669] mutArray.mutCopy ---tempMutCopyStr.p = 0x600002c17330,tempMutCopyStr = __NSCFString,tempMutCopyStr.class = 可变对象兮
     */
    NSLog(@"\n mutArray.p = %p mutArray.class = %@  \n mutArray.copy.p = %p mutArray.copy.Class = %@\n mutArray.mutCopy.p = %p,mutArray.mutCopy.p= %@",mutArray,[mutArray class],[mutArray copy],[[mutArray copy] class],[mutArray mutableCopy],[[mutArray mutableCopy] class]);
    for (id tempStr in mutArray) {
        NSLog(@"mutArray ---tempStr.p = %p,tempStr = %@,tempStr.class = %@\n",tempStr,[tempStr class],tempStr);
    }
    for (id tempCopyStr in [mutArray copy]) {
        NSLog(@"mutArray.copy ---tempCopyStr.p = %p,tempCopyStr = %@,tempCopyStr.class = %@\n",tempCopyStr,[tempCopyStr class],tempCopyStr);
    }
    
    for (id tempMutCopyStr in [mutArray mutableCopy]) {
        NSLog(@"mutArray.mutCopy ---tempMutCopyStr.p = %p,tempMutCopyStr = %@,tempMutCopyStr.class = %@\n",tempMutCopyStr,[tempMutCopyStr class],tempMutCopyStr);
    }
    /*
     结论：对于容器类可变对象 执行copy，深拷贝，地址不同，返回的是不可变对象
     执行mutableCopy，深拷贝，地址不同，返回的是不可变对象
     容器内的独享（无论可变或不可变），均为浅拷贝（地址相同）
     */
    
    
    
}
/**
 容器类对象 copy或mutableCopy （本方法是针对数组）
 */
- (void)imArrayCopyAndMutCopy
{
    NSString *immutableStr = @"不可变对象";
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"可变对象兮"];
    NSArray *imArray = [NSArray arrayWithObjects:immutableStr,mutableStr, nil];
    NSArray *imArrayCopy = [imArray copy];
    NSArray *imArrayMutCopy = [imArray mutableCopy];
    /*
     imArray.p = 0x60000259d960 imArray.class = __NSArrayI
     imArrayCopy.p = 0x60000259d960 imArrayCopy.class = __NSArrayI
     imArrayMutCopy.p = 0x600002b839f0,imArrayMutCopy.class= __NSArrayM
     2019-03-03 12:13:35.401764+0800 MyNewTestDemo[13557:3186194] imArray ---tempStr.p = 0x1098d4088,tempStr = __NSCFConstantString,tempStr.class = 不可变对象
     2019-03-03 12:13:35.401864+0800 MyNewTestDemo[13557:3186194] imArray ---tempStr.p = 0x600002b83b70,tempStr = __NSCFString,tempStr.class = 可变对象兮
     2019-03-03 12:13:35.401945+0800 MyNewTestDemo[13557:3186194] imArrayCopy ---tempCopyStr.p = 0x1098d4088,tempCopyStr = __NSCFConstantString,tempCopyStr.class = 不可变对象
     2019-03-03 12:13:35.402043+0800 MyNewTestDemo[13557:3186194] imArrayCopy ---tempCopyStr.p = 0x600002b83b70,tempCopyStr = __NSCFString,tempCopyStr.class = 可变对象兮
     2019-03-03 12:13:35.402111+0800 MyNewTestDemo[13557:3186194] imArrayMutCopy ---tempMutCopyStr.p = 0x1098d4088,tempMutCopyStr = __NSCFConstantString,tempMutCopyStr.class = 不可变对象
     2019-03-03 12:13:35.402171+0800 MyNewTestDemo[13557:3186194] imArrayMutCopy ---tempMutCopyStr.p = 0x600002b83b70,tempMutCopyStr = __NSCFString,tempMutCopyStr.class = 可变对象兮
     */
    NSLog(@"\n imArray.p = %p imArray.class = %@  \n imArrayCopy.p = %p imArrayCopy.class = %@\n imArrayMutCopy.p = %p,imArrayMutCopy.class= %@",imArray,[imArray class],imArrayCopy,[imArrayCopy class],imArrayMutCopy,[imArrayMutCopy class]);
    
    for (id tempStr in imArray) {
        NSLog(@"imArray ---tempStr.p = %p,tempStr = %@,tempStr.class = %@\n",tempStr,[tempStr class],tempStr);
    }
    for (id tempCopyStr in imArrayCopy) {
        NSLog(@"imArrayCopy ---tempCopyStr.p = %p,tempCopyStr = %@,tempCopyStr.class = %@\n",tempCopyStr,[tempCopyStr class],tempCopyStr);
    }
    
    for (id tempMutCopyStr in imArrayMutCopy) {
        NSLog(@"imArrayMutCopy ---tempMutCopyStr.p = %p,tempMutCopyStr = %@,tempMutCopyStr.class = %@\n",tempMutCopyStr,[tempMutCopyStr class],tempMutCopyStr);
    }
    /*
     结论：对于容器类的不可变对象 执行copy 对于容器来说是浅copy，地址相同，且返回的是不可变对象
     执行mutableCopy 对于容器来说是深拷贝，地址不同，且返回的是可变对象。
     对于容器内的对象（可变或不可变对象）而言，无论容器执行的是copy还是mutableCopy，这些对象执行的都是浅拷贝
     */
    
}

/**
 非容器类可变对象执行 copy 和 mutableCopy
 */
- (void)mutableStrCopyAndMutCopy
{
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"可变字符串"];
    
    NSMutableString *mutableStrCopy = [mutableStr copy];
    //copy 之后 变为不可变对象，不可执行拼接操作，窒息该操作，直接崩溃！！
    //    [mutableStrCopy appendString:@"copy 之后拼接"];
    NSMutableString *mutableStrMutCopy = [mutableStr mutableCopy];
    [mutableStrMutCopy appendString:@"mutcopy"];
    /*
     mutableStr.p = 0x600001589230 mutableStr.class = __NSCFString mutableStr = 可变字符串
     mutableStrCopy.p = 0x6000015890b0 mutableStrCopy.class = __NSCFString,mutableStrCopy = 可变字符串
     mutableStrMutCopy.p = 0x6000015887b0,mutableStrMutCopy.class= __NSCFString，mutableStrMutCopy = 可变字符串mutcopy
     */
    NSLog(@"\n mutableStr.p = %p mutableStr.class = %@ mutableStr = %@ \n mutableStrCopy.p = %p mutableStrCopy.class = %@,mutableStrCopy = %@\n mutableStrMutCopy.p = %p,mutableStrMutCopy.class= %@，mutableStrMutCopy = %@",mutableStr,[mutableStr class],mutableStr,mutableStrCopy,[mutableStrCopy class],mutableStrCopy,mutableStrMutCopy,[mutableStrMutCopy class],mutableStrMutCopy);
    /*
     结论：
     对于非容器类的可变对象 执行 copy
     */
    
}
/**
 非容器类不可变对象 执行copy 和 mutbleCopy
 */
- (void)immutableStrCopyAndMutCopy
{
    NSString *immutableStr = @"不可变字符串";
    NSMutableString *immutableStrCopy = [immutableStr copy];
    NSMutableString *immutableStrMutCopy = [immutableStr mutableCopy];
    //    [immutableStrCopy appendString:@"22"];
    [immutableStrMutCopy appendString:@"33"];
    NSLog(@"immutableStrMutCopy = %@",immutableStrMutCopy);
    /*
     immutableStr_p = 0x107a58068 immutableStr = __NSCFConstantString
     immutableStrCopy_p = 0x107a58068 immutableStrCopy = __NSCFConstantString,
     immutableStrMutCopy_p = 0x6000034e07e0,immutableStrMutCopy= __NSCFString
     __NSCFConstantString 表示对象存储在常量区，__NSCFString表示对象存储在堆上
     */
    NSLog(@"\n immutableStr_p = %p immutableStr = %@ \n immutableStrCopy_p = %p immutableStrCopy = %@,\n immutableStrMutCopy_p = %p,immutableStrMutCopy= %@",immutableStr,[immutableStr class],immutableStrCopy,[immutableStrCopy class],immutableStrMutCopy,[immutableStrMutCopy class]);
    /*
     结论：对非容器类的不可变对象 执行copy 是浅拷贝,地址相同，返回的也是不可变对象
     执行mutableCopy 是深拷贝，地址不同，返回的是可变对象
     */
}




@end
