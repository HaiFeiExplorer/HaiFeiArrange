//
//  HFMutThreadHomeViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/10.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFMutThreadHomeViewController.h"

@interface HFMutThreadHomeViewController ()

@end

@implementation HFMutThreadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"多线程";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self installSubViews];
}


#pragma mark - Event response
- (void)mutThreadButtonAction
{
    NSLog(@"GCD Action");
//    HFMutThreadHomeViewController *mutThraedVC = [[HFMutThreadHomeViewController alloc]init];
//    [self.navigationController pushViewController:mutThraedVC animated:YES];
}


#pragma mark - Private methdods

- (void)installSubViews
{
    
    UIButton *mutThreaBut = [UIButton buttonWithType:UIButtonTypeCustom];
    mutThreaBut.frame = CGRectMake(10, 100, 100, 40);
    mutThreaBut.backgroundColor = [UIColor blueColor];
    [mutThreaBut setTitle:@"GCD" forState:UIControlStateNormal];
    mutThreaBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [mutThreaBut addTarget:self action:@selector(mutThreadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mutThreaBut];
    
    
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
