//
//  HFHomeViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/10.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFHomeViewController.h"
#import "HFMutThreadHomeViewController.h"

@interface HFHomeViewController ()


@end

@implementation HFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    [self installSubViews];
}

#pragma mark - Event response
- (void)mutThreadButtonAction
{
    HFMutThreadHomeViewController *mutThraedVC = [[HFMutThreadHomeViewController alloc]init];
    [self.navigationController pushViewController:mutThraedVC animated:YES];
}


#pragma mark - Private methdods

- (void)installSubViews
{
    
    UIButton *mutThreaBut = [UIButton buttonWithType:UIButtonTypeCustom];
    mutThreaBut.frame = CGRectMake(10, 100, 100, 40);
    mutThreaBut.backgroundColor = [UIColor blueColor];
    [mutThreaBut setTitle:@"多线程" forState:UIControlStateNormal];
    mutThreaBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [mutThreaBut addTarget:self action:@selector(mutThreadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mutThreaBut];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
