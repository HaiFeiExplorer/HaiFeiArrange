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



@end
