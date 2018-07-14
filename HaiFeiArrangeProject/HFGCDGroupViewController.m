//
//  HFGCDGroupViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/14.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFGCDGroupViewController.h"

@interface HFGCDGroupViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) NSMutableArray *mutButtonArray;

@end

@implementation HFGCDGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Event response
- (void)buttonActions:(UIButton *)button
{
    switch (button.tag) {
        case 1000:
            
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
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"串行+同步",@"串行+异步",@"并行+同步",@"并行+异步",@"dispatch_apply",@"dispatch_barrier_async",@"dispatch_after",@"dispatch_once",@"dispatch_group_notify", @"dispatch_group_wait",@"dispatch_semaphore",@"dispatch_group_enterAndLeave",nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
