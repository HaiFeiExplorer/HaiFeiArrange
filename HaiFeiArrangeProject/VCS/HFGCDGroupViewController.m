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
    dispatch_queue_t tempConQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
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
     关于dispatch_barrier 必须加入到自定义的DISPATCH_QUEUE_CONCURRENT队列中，加入到global queue中dispatch_barrier将会无效
     */
    NSLog(@"main ---1--");

    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test1 begin - ");

        sleep(3);
        NSLog(@"test1 - end - ");
    });
    NSLog(@"main ---2--");

    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test2 begin - ");
        
        sleep(3);
        NSLog(@"test2 - end - ");
        
    });
    NSLog(@"main ---3--");
    dispatch_barrier_sync(self.concurrentQueue, ^{///分界线在这里 请注意是同步的
        sleep(1);
        for (int i = 0; i<10; i++) {
            if (i == 4 ) {
                NSLog(@"barrier -- 4");
            }else if(i == 8){
                NSLog(@"barrier -- 8");
            }
        }
    });
    NSLog(@"main ---4--");
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test4 begin - ");
        
        sleep(3);
        NSLog(@"test4 - end - ");
        
    });
    NSLog(@"main ---5--");
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test5 begin - ");
        sleep(3);
        NSLog(@"test5 - end - ");
        
    });
    NSLog(@"main ---6--");

    /*
     dispatch_barrier_sync(queue,void(^block)())会将queue中barrier前面添加的任务block全部执行后,再执行barrier任务的block,再执行barrier后面添加的任务block,同时阻塞住线程.
     dispatch_barrier_async(queue,void(^block)())会将queue中barrier前面添加的任务block只添加不执行,继续添加barrier的block,再添加barrier后面的block,同时不影响主线程(或者操作添加任务的线程)中代码的执行!
     若将dispatch_barrier加入到global队列中，dispatch_barrier无效
     */
}
- (void)dispatchAfterTest
{
    
}
- (void)dispatchOnceTest
{
    
}
- (void)dispatchGroupNotify
{
    
}
- (void)dispatchGroupWaitTest
{
    
}
- (void)dispatchSemaphoreTest
{
    
}
- (void)dispatchGroupEnterAndLeaveTest
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
