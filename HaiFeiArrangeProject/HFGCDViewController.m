//
//  HFGCDViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/11.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFGCDViewController.h"

@interface HFGCDViewController ()


@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) dispatch_queue_t otherconcurrentQueue;



@end

@implementation HFGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)installSubViews
{
    //串行队列
    self.serialQueue = dispatch_queue_create("serialQueue.ys.com", DISPATCH_QUEUE_SERIAL);
    //并行队列
    self.concurrentQueue = dispatch_queue_create("concurrentQueue.ys.com", DISPATCH_QUEUE_CONCURRENT);
    self.otherconcurrentQueue = dispatch_queue_create("otherConcurrentQueue.ys.com", DISPATCH_QUEUE_CONCURRENT);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
