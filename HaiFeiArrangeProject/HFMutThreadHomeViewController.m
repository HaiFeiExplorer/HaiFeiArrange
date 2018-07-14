//
//  HFMutThreadHomeViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/10.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFMutThreadHomeViewController.h"
#import "HFQueueAndOperationViewController.h"

@interface HFMutThreadHomeViewController ()


@property (nonatomic, strong) NSMutableArray *mutButtonArray;
@property (nonatomic, strong) NSMutableArray *mutSecondVCArray;
@end

@implementation HFMutThreadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"多线程";
    
    [self installArray];
    [self installSubButtons];
    
}



#pragma mark - Event response
- (void)buttonActions:(UIButton *)button
{
    NSInteger tag = button.tag - 9000;
    NSString *tempVCStr = self.mutSecondVCArray[tag];
    id tempVC = [[NSClassFromString(tempVCStr) alloc]init];
    if(tempVC){
        [self.navigationController pushViewController:tempVC animated:YES];

    }else{
        NSLog(@"尚未完善");
    }
    
}


#pragma mark - Private methdods
- (void)installArray
{
    self.mutSecondVCArray = [NSMutableArray arrayWithObjects:@"HFQueueAndOperationViewController",@"", nil];
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"队列andGCD",@"NSOperation", nil];

}
- (void)installSubButtons
{
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 100;
    CGFloat butttonSpace = 10;
    for (int i = 0; i < self.mutButtonArray.count; i++) {
        UIButton *tempButon = [UIButton buttonWithType:UIButtonTypeCustom];
        tempButon.tag = 9000 + i;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
