//
//  HFGCDGroupViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/14.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFGCDGroupViewController.h"

static NSString *const kHFGCDCellID = @"kHFGCDCellID";


@interface HFGCDGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) NSMutableArray *mutButtonArray;

@property (nonatomic, strong) UITableView *mainTableView;


@end

@implementation HFGCDGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"GCD";
    [self installSubQueue];
    [self installButtonArray];
    [self installMainTableView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutButtonArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHFGCDCellID];
    cell.textLabel.text = self.mutButtonArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectRow = indexPath.row;
    switch (selectRow) {
        case 0:
            [self dispatchBarrierTest];
            break;
        case 1:
            [self dispatchAfterTest];
            break;
        case 2:
            [self dispatchOnceTest];
            break;
        case 3:
            [self dispatchGroupNotify];
            break;
        case 4:
            [self dispatchGroupWaitTest];
            break;
        case 5:
            [self dispatchSemaphoreTest];
            break;
        case 6:
            [self dispatchGroupEnterAndLeaveTest];
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
- (void)installMainTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHFGCDCellID];
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.rowHeight = 50;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}
- (void)installButtonArray
{
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"dispatch_barrier",@"dispatch_after",@"dispatch_once",@"dispatch_group_notify", @"dispatch_group_wait",@"dispatch_semaphore",@"dispatch_group_enterAndLeave",nil];
}

- (void)dispatchBarrierTest
{
    /*
     dispatch_barrier
     Barrier blocks only behave specially when submitted to queues created with
     * the DISPATCH_QUEUE_CONCURRENT attribute; on such a queue, a barrier block
     * will not run until all blocks submitted to the queue earlier have completed,
     * and any blocks submitted to the queue after a barrier block will not run
     * until the barrier block has completed.
     * When submitted to a a global queue or to a queue not created with the
     * DISPATCH_QUEUE_CONCURRENT attribute, barrier blocks behave identically to
     * blocks submitted with the dispatch_async()/dispatch_sync() API.
     */
    NSLog(@"main ---1--");

    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test1 begin - ");

        sleep(3);
        NSLog(@"test1 - end - ");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test2 begin - ");
        
        sleep(3);
        NSLog(@"test2 - end - ");
        
    });
    dispatch_barrier_async(self.concurrentQueue, ^{///分界线在这里 请注意是同步的
        NSLog(@"barrier -- start");
        sleep(1);
        NSLog(@"barrier -- end");

    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test4 begin - ");
        
        sleep(3);
        NSLog(@"test4 - end - ");
        
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test5 begin - ");
        sleep(3);
        NSLog(@"test5 - end - ");
        
    });
    NSLog(@"main ---6--");

    /*
     dispatch_barrier_sync(queue,void(^block)())会将queue中barrier前面添加的任务block全部执行后,再执行barrier任务的block,再执行barrier后面添加的任务block,同时阻塞住线程.
     2019-01-26 14:10:03.909859+0800 HaiFeiArrangeProject[28531:342041] main ---1--
     2019-01-26 14:10:03.910086+0800 HaiFeiArrangeProject[28531:342080] test1 begin -
     2019-01-26 14:10:03.910101+0800 HaiFeiArrangeProject[28531:342081] test2 begin -
     2019-01-26 14:10:06.913917+0800 HaiFeiArrangeProject[28531:342081] test2 - end -
     2019-01-26 14:10:06.913964+0800 HaiFeiArrangeProject[28531:342080] test1 - end -
     2019-01-26 14:10:06.914284+0800 HaiFeiArrangeProject[28531:342041] barrier -- start
     2019-01-26 14:10:07.915035+0800 HaiFeiArrangeProject[28531:342041] barrier -- end
     2019-01-26 14:10:07.915219+0800 HaiFeiArrangeProject[28531:342041] main ---6--
     2019-01-26 14:10:07.915247+0800 HaiFeiArrangeProject[28531:342081] test4 begin -
     2019-01-26 14:10:07.915251+0800 HaiFeiArrangeProject[28531:342082] test5 begin -
     2019-01-26 14:10:10.919249+0800 HaiFeiArrangeProject[28531:342081] test4 - end -
     2019-01-26 14:10:10.919276+0800 HaiFeiArrangeProject[28531:342082] test5 - end -
     
     dispatch_barrier_async(queue,void(^block)())会将queue中barrier前面添加的任务block只添加不执行,继续添加barrier的block,再添加barrier后面的block,同时不影响主线程(或者操作添加任务的线程)中代码的执行!
     
     2019-01-26 14:10:42.327067+0800 HaiFeiArrangeProject[28551:342894] main ---1--
     2019-01-26 14:10:42.327227+0800 HaiFeiArrangeProject[28551:342894] main ---6--
     2019-01-26 14:10:42.327229+0800 HaiFeiArrangeProject[28551:342934] test1 begin -
     2019-01-26 14:10:42.327253+0800 HaiFeiArrangeProject[28551:342935] test2 begin -
     2019-01-26 14:10:45.331341+0800 HaiFeiArrangeProject[28551:342934] test1 - end -
     2019-01-26 14:10:45.331341+0800 HaiFeiArrangeProject[28551:342935] test2 - end -
     2019-01-26 14:10:45.331612+0800 HaiFeiArrangeProject[28551:342935] barrier -- start
     2019-01-26 14:10:46.336684+0800 HaiFeiArrangeProject[28551:342935] barrier -- end
     2019-01-26 14:10:46.336910+0800 HaiFeiArrangeProject[28551:342935] test4 begin -
     2019-01-26 14:10:46.336911+0800 HaiFeiArrangeProject[28551:342934] test5 begin -
     2019-01-26 14:10:49.341715+0800 HaiFeiArrangeProject[28551:342934] test5 - end -
     2019-01-26 14:10:49.341715+0800 HaiFeiArrangeProject[28551:342935] test4 - end -

     简单说：sync 阻塞主线程；async：不阻塞！ 参看打印的“main ---6--”！！！
     */
    
    /*
     需要注意的：
     若将dispatch_barrier加入到global队列中，dispatch_barrier无效
     在使用栅栏函数时.使用自定义队列才有意义,如果用的是串行队列或者系统提供的全局并发队列,这个栅栏函数的作用等同于一个同步函数的作用
     */
}
- (void)dispatchAfterTest
{
    NSLog(@"进入 dispatchAfterTest 方法");
    /*
     DISPATCH_TIME_NOW，表示从现在开始。
     DISPATCH_TIME_FOREVER，表示遥远的未来
     
     NSEC：纳秒。
     USEC：微妙。
     MSEC：毫秒
     SEC：秒
     PER：每
     
     1s=10的3次方 ms(毫秒)
       =10的6次方μs(微秒)
       =10v的9次方ns(纳秒)
     
     #define NSEC_PER_SEC 1000000000ull 每秒有多少纳秒
     #define NSEC_PER_MSEC 1000000ull 每毫秒有多少纳秒
     #define USEC_PER_SEC 1000000ull 每秒有多少微秒。（注意是指在纳秒的基础上）
     #define NSEC_PER_USEC 1000ull 每微秒有多少纳秒。
     
     dispatch_after函数并不是延迟对应时间后立即执行block块中的操作，而是将任务追加到对应的队列中，考虑到队列阻塞等情况，所以这个任务从加入队列到真正执行的时间并不准确！
     
     3.0 * NSEC_PER_SEC 表示：3秒
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"执行任务");
        
    });
}
typedef void (^TestBlock)(void);
TestBlock myTestBlock=^(){
    static int count = 0;
    NSLog(@"count = %d",count ++);
    
};
- (void)dispatchOnceTest
{
    /*
     dispatch_once 一般多用于单例构造方法中，目前尚未在其他方法中使用过！ 关于单例构造的具体实现也不仅仅只有这个还需要重写其他的方法！ 之后完善 单例！！！
     使用dispatch_once需要注意：其block中的包裹的内容，尽量避免与其他类耦合！
     */
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, myTestBlock);
    dispatch_once(&onceToken, myTestBlock);

    //虽然执行两次,只有一个输出
    /*
     2019-01-26 15:37:15.438356+0800 HaiFeiArrangeProject[29785:403238] count = 0
     */
}


- (void)dispatchGroupNotify
{
    /*
     这个代码是 加入到group中的异步操作 这个操作内部是同步的，在这样的情况下 可以如下使用，但是如果异步操作内部也是异步 就需要配合enter和leave实现目前实现的效果！ 参看enter 和 leave的操作
     */
    
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"----group--start----");

    //封装任务
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(2);
        NSLog(@"1----------%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(1);
        NSLog(@"2----------%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(3);
        NSLog(@"3----------%@",[NSThread currentThread]);
    });
    
    //4.拦截通知
    dispatch_group_notify(group, self.concurrentQueue, ^{
        NSLog(@"---dispatch_group_notify------%@",[NSThread currentThread]);
    });
    //不用等待 队列执行完就会执行这个代码
    NSLog(@"----group--end----");

    
    
}
- (void)dispatchGroupWaitTest
{
  /*
  这里起了3个异步线程放在一个组里，之后通过dispatch_time_t创建了一个超时时间（2秒），程序之后行，立即输出了aaaaa，这是主线程输出的，当遇到dispatch_group_wait时，主线程会被挂起，等待2秒，在等待的过程当中，子线程分别输出了1和2，2秒时间达到后，主线程发现组里的任务并没有全部结束，然后输出了main。
   　　在这里，如果超时时间设置得比较长（比如5秒），那么会在3秒时第三个任务结束后，立即输出main，也就是说，当组中的任务全部执行完毕时，主线程就不再被阻塞了。
   　　如果希望永久等待下去，时间可以设置为DISPATCH_TIME_FOREVER
   */

    dispatch_group_t group = dispatch_group_create();
    //异步
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(2);
        NSLog(@"1");
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(1.5);
        NSLog(@"2");
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(3);
        NSLog(@"3");
    });
    NSLog(@"aaaaa");
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    long result = dispatch_group_wait(group, time);
    if (result == 0){
        // 属于Dispatch Group的Block全部处理结束
        NSLog(@"全部处理结束");
    }else{
        // 属于Dispatch Group的某一个处理还在执行中
        NSLog(@"某一个处理还在执行中");
    }
    NSLog(@"main");
    /*
    等待2秒的打印输出：
     2019-01-26 15:56:15.450252+0800 HaiFeiArrangeProject[30168:420683] aaaaa
     2019-01-26 15:56:16.453528+0800 HaiFeiArrangeProject[30168:420709] 2
     2019-01-26 15:56:17.451638+0800 HaiFeiArrangeProject[30168:420683] 某一个处理还在执行中
     2019-01-26 15:56:17.451927+0800 HaiFeiArrangeProject[30168:420683] main
     2019-01-26 15:56:17.453986+0800 HaiFeiArrangeProject[30168:420707] 1
     2019-01-26 15:56:18.453192+0800 HaiFeiArrangeProject[30168:420706] 3

     
     当等待时间是5秒的时候的打印结果：
     2019-01-26 15:57:15.072096+0800 HaiFeiArrangeProject[30189:421617] aaaaa
     2019-01-26 15:57:16.075428+0800 HaiFeiArrangeProject[30189:421665] 2
     2019-01-26 15:57:17.076848+0800 HaiFeiArrangeProject[30189:421915] 1
     2019-01-26 15:57:18.072394+0800 HaiFeiArrangeProject[30189:421920] 3
     2019-01-26 15:57:18.072845+0800 HaiFeiArrangeProject[30189:421617] 全部处理结束
     2019-01-26 15:57:18.073139+0800 HaiFeiArrangeProject[30189:421617] main

     */
    
}
- (void)dispatchSemaphoreTest
{
    
    /*
     //创建信号量，参数：信号量的初值，如果小于0则会返回NULL
     dispatch_semaphore_create（信号量值）
     //等待降低信号量
     dispatch_semaphore_wait（信号量，等待时间）
     //提高信号量
     dispatch_semaphore_signal(信号量)
     正常的使用顺序是先降低然后再提高，这两个函数通常成对使用
     */
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
//
//    //任务1
//    dispatch_async(self.concurrentQueue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        NSLog(@"-- 1--begin");
//        sleep(2);
//        NSLog(@"-- 1--end");
//        dispatch_semaphore_signal(semaphore);
//    });
//    //任务2
//    dispatch_async(self.concurrentQueue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        NSLog(@"-- 2--begin");
//        sleep(3);
//        NSLog(@"-- 2--end");
//        dispatch_semaphore_signal(semaphore);
//    });
//    //任务3
//    dispatch_async(self.concurrentQueue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        NSLog(@"-- 3--begin");
//        sleep(2);
//        NSLog(@"-- 3--end");
//        dispatch_semaphore_signal(semaphore);
//    });
//    //任务4
//    dispatch_async(self.concurrentQueue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        NSLog(@"-- 4--begin");
//        sleep(1);
//        NSLog(@"-- 4--end");
//        dispatch_semaphore_signal(semaphore);
//    });
    
    dispatch_group_t group = dispatch_group_create();

    for (int i = 0; i < 10; i++) {
        dispatch_group_async(group, self.concurrentQueue, ^{
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%d --- 开始 --",i + 1 );
            // 线程操作区域 最多有两个线程在此做事情
            sleep(2);
           
            NSLog(@"%d --- end --",i + 1 );

            dispatch_semaphore_signal(semaphore);
        });
    }
    // group任务全部执行完毕回调
    dispatch_group_notify(group, self.concurrentQueue, ^{
        NSLog(@"done");
    });
    
}
- (void)dispatchGroupEnterAndLeaveTest
{
    
    dispatch_group_t group =dispatch_group_create();

    
    dispatch_group_enter(group);
    
    //模拟多线程耗时操作
    dispatch_group_async(group, self.concurrentQueue, ^{
        
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"1---1--begin");
            sleep(3);
            NSLog(@"1---1--end");
            dispatch_group_leave(group);
            
        });
        
    });
    
    dispatch_group_enter(group);
    //模拟多线程耗时操作
    dispatch_group_async(group, self.concurrentQueue, ^{
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"2---2--begin");
            sleep(2);
            NSLog(@"2--2-end");
            dispatch_group_leave(group);
            
        });
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@---全部done。。。",[NSThread currentThread]);
    });
    
    NSLog(@"main");
    /*
      使用enter 和 leave 的打印结果：
     2019-01-26 16:32:11.860953+0800 HaiFeiArrangeProject[30753:447579] 1---1--begin
     2019-01-26 16:32:11.860953+0800 HaiFeiArrangeProject[30753:447327] main
     2019-01-26 16:32:11.860957+0800 HaiFeiArrangeProject[30753:447367] 2---2--begin
     2019-01-26 16:32:13.861316+0800 HaiFeiArrangeProject[30753:447367] 2--2-end
     2019-01-26 16:32:14.866069+0800 HaiFeiArrangeProject[30753:447579] 1---1--end
     2019-01-26 16:32:14.866708+0800 HaiFeiArrangeProject[30753:447579] <NSThread: 0x6000000f0b40>{number = 3, name = (null)}---全部done。。。
    
     注释掉 enter leave 之后的打印结果：可以发现并不符合我们的预期！
     2019-01-26 16:33:19.111523+0800 HaiFeiArrangeProject[30784:448544] 1---1--begin
     2019-01-26 16:33:19.111520+0800 HaiFeiArrangeProject[30784:448504] main
     2019-01-26 16:33:19.111544+0800 HaiFeiArrangeProject[30784:448871] 2---2--begin
     2019-01-26 16:33:19.111605+0800 HaiFeiArrangeProject[30784:448868] <NSThread: 0x6000019c3600>{number = 3, name = (null)}---全部done。。。
     2019-01-26 16:33:21.113975+0800 HaiFeiArrangeProject[30784:448871] 2--2-end
     2019-01-26 16:33:22.114889+0800 HaiFeiArrangeProject[30784:448544] 1---1--end
     
    
     结论：
     1、在加入group的异步操作其内部如果是同步操作，enter和leave加不加均可，若其内部是异步操作，必须使用enter和leave
     2、enter 和 leave 必须是成对的出现：若一对enter和leave 只有enter 会导致notify用不执行，如果只有leave，会直接崩溃！

     */
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
