//
//  HFQueueAndOperationViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/12.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFQueueAndOperationViewController.h"

@interface HFQueueAndOperationViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;


@property (nonatomic, strong) NSMutableArray *mutButtonArray;
@end

@implementation HFQueueAndOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"队列和操作";
    self.view.backgroundColor = [UIColor whiteColor];
    [self installSubQueue];
    [self installSubButtons];
}

#pragma mark - Event response
- (void)buttonActions:(UIButton *)button
{
    switch (button.tag) {
        case 1000:
            //串行队列＋同步任务：不会开启新的线程，任务逐步完成。
            [self creatSyOperstionWithTag:__LINE__ concurrent:NO];
            [self creatSyOperstionWithTag:__LINE__ concurrent:NO];
            break;
        case 1001:
            //串行队列＋异步任务：可能开启新的线程，任务逐步完成。
            [self creatAyOperstionWithTag:__LINE__ concurrent:NO];
            [self creatAyOperstionWithTag:__LINE__ concurrent:NO];
            break;
        case 1002:
            //并发队列＋同步任务：不会开启新的线程，任务逐步完成。
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            break;
        case 1003:
            //并发队列＋异步任务：开启新的线程，任务同步完成。
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            break;
        case 1004:
            [self creatDispatchApplyActon];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private methods
- (void)installSubQueue
{
    //串行队列
    self.serialQueue = dispatch_queue_create("serialQueue.ys.com", DISPATCH_QUEUE_SERIAL);
    //并行队列
    self.concurrentQueue = dispatch_queue_create("concurrentQueue.ys.com", DISPATCH_QUEUE_CONCURRENT);
}
- (void)installSubButtons
{
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"串行+同步",@"串行+异步",@"并行+同步",@"并行+异步",@"dispatch_apply", nil];
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 100;
    CGFloat butttonSpace = 10;
    for (int i = 0; i < self.mutButtonArray.count; i++) {
        UIButton *tempButon = [UIButton buttonWithType:UIButtonTypeCustom];
        tempButon.tag = 1000 + i;
        tempButon.frame = CGRectMake(10, 50 + butttonSpace*i + buttonHeight*i, buttonWidth, buttonHeight);
        [tempButon addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
        [tempButon setTitle:self.mutButtonArray[i] forState:UIControlStateNormal];
        tempButon.backgroundColor = [UIColor blueColor];
        tempButon.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:tempButon];
    }
}
//创建同步操作
- (void)creatSyOperstionWithTag:(NSInteger)tag concurrent:(BOOL)concurrent
{
    if (concurrent) {
        //并行队列
        dispatch_sync(self.concurrentQueue, ^{
            NSLog(@"start 任务所在行数%ld - %@，",(long)tag,[NSThread currentThread]);
            sleep(3);
            NSLog(@"end 任务所在行数%ld - %@，",(long)tag,[NSThread currentThread]);
        });
    }else{
        //串行队列
        dispatch_sync(self.serialQueue, ^{
            NSLog(@"start 任务所在行数%ld - %@，",(long)tag,[NSThread currentThread]);
            sleep(3);
            NSLog(@"end 任务所在行数%ld - %@，",(long)tag,[NSThread currentThread]);
        });
    }
  
}
//创建异步操作
- (void)creatAyOperstionWithTag:(NSInteger)tag concurrent:(BOOL)concurrent
{
    if (concurrent) {
        //并行队列
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"start 任务%ld - %@，",(long)tag,[NSThread currentThread]);
            sleep(3);
            NSLog(@"end 任务%ld - %@，",(long)tag,[NSThread currentThread]);
        });
    }else{
        //串行队列
        dispatch_async(self.serialQueue, ^{
            NSLog(@"start 任务%ld - %@，",(long)tag,[NSThread currentThread]);
            sleep(3);
            NSLog(@"end 任务%ld - %@，",(long)tag,[NSThread currentThread]);
        });
    }
}

- (void)creatDispatchApplyActon
{
    dispatch_apply(5, self.concurrentQueue, ^(size_t i) {
        NSLog(@"开始concurrentQueue -第%@次_%@",@(i),[NSThread currentThread]);
        sleep(3);
        NSLog(@"结束concurrentQueue -第%@次_%@",@(i),[NSThread currentThread]);

    });
    NSLog(@"all done");
/*
 dispatch_apply在串行队列中按照顺序执行，完全没有意义.
 在并发队列中创建了N个任务，但并非所有任务不开辟线程，也有在主线程中完成的。
 对应的打印日志
 2018-07-12 16:33:22.387729+0800 HaiFeiArrangeProject[44025:14367838] 开始concurrentQueue -第0次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:22.388144+0800 HaiFeiArrangeProject[44025:14367856] 开始concurrentQueue -第1次_<NSThread: 0x1c4464080>{number = 3, name = (null)}
 2018-07-12 16:33:25.389445+0800 HaiFeiArrangeProject[44025:14367838] 结束concurrentQueue -第0次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:25.389724+0800 HaiFeiArrangeProject[44025:14367838] 开始concurrentQueue -第2次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:25.389968+0800 HaiFeiArrangeProject[44025:14367856] 结束concurrentQueue -第1次_<NSThread: 0x1c4464080>{number = 3, name = (null)}
 2018-07-12 16:33:25.390124+0800 HaiFeiArrangeProject[44025:14367856] 开始concurrentQueue -第3次_<NSThread: 0x1c4464080>{number = 3, name = (null)}
 2018-07-12 16:33:28.391106+0800 HaiFeiArrangeProject[44025:14367838] 结束concurrentQueue -第2次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:28.391387+0800 HaiFeiArrangeProject[44025:14367838] 开始concurrentQueue -第4次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:28.394775+0800 HaiFeiArrangeProject[44025:14367856] 结束concurrentQueue -第3次_<NSThread: 0x1c4464080>{number = 3, name = (null)}
 2018-07-12 16:33:31.392771+0800 HaiFeiArrangeProject[44025:14367838] 结束concurrentQueue -第4次_<NSThread: 0x1c4069800>{number = 1, name = main}
 2018-07-12 16:33:31.392969+0800 HaiFeiArrangeProject[44025:14367838] all done
 */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
