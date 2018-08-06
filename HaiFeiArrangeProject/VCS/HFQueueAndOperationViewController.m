//
//  HFQueueAndOperationViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/12.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFQueueAndOperationViewController.h"
#import "HFGCDGroupViewController.h"


#define kQueueAndOperationViewCellID @"kQueueAndOperationViewCellID"

@interface HFQueueAndOperationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) NSMutableArray *mutButtonArray;

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation HFQueueAndOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"队列和操作";
    [self installButtonArray];
    [self installSubQueue];
    [self installMainTableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutButtonArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQueueAndOperationViewCellID];
    cell.textLabel.text = self.mutButtonArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectRow = indexPath.row;
    switch (selectRow) {
        case 0:
            //串行队列＋同步任务：不会开启新的线程，任务逐步完成。
            [self creatSyOperstionWithTag:__LINE__ concurrent:NO];
            [self creatSyOperstionWithTag:__LINE__ concurrent:NO];
            break;
        case 1:
            //串行队列＋异步任务：可能开启新的线程，任务逐步完成。
            [self creatAyOperstionWithTag:__LINE__ concurrent:NO];
            [self creatAyOperstionWithTag:__LINE__ concurrent:NO];
            break;
        case 2:
            //并发队列＋同步任务：不会开启新的线程，任务逐步完成。
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatSyOperstionWithTag:__LINE__ concurrent:YES];
            break;
        case 3:
            //并发队列＋异步任务：开启新的线程，任务同步完成。
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            [self creatAyOperstionWithTag:__LINE__ concurrent:YES];
            break;
        case 4:
            [self creatDispatchApplyActon];
            break;
        case 5:
            [self pushGCDVC];
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
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kQueueAndOperationViewCellID];
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.rowHeight = 50;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}
- (void)installButtonArray
{
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"串行+同步",@"串行+异步",@"并行+同步",@"并行+异步",@"dispatch_apply",@"dispatch_group",nil];
}
- (void)pushGCDVC
{
    HFGCDGroupViewController *groupVC = [[HFGCDGroupViewController alloc]init];
    [self.navigationController pushViewController:groupVC animated:YES];
    
}
/**
 创建同步步操作
 
 @param tag 调用本函数时所在的行数
 @param concurrent YES 加入到并行队列，NO是加入到串行队列
 */
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
/**
 创建异步操作

 @param tag 调用本函数时所在的行数
 @param concurrent YES 加入到并行队列，NO是加入到串行队列
 */
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
