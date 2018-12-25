//
//  HFHomeViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/10.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFHomeViewController.h"
#import "HFMutThreadHomeViewController.h"
#import "HFConstStaticExternViewController.h"
#import "HFRuntimeAndMethodsViewController.h"
#import "HFInterfaceAndAPIViewController.h"
#import "HFProtocolAndCategoryViewController.h"

static NSString *const kHFGCDCellID = @"kHFGCDCellID";

@interface HFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *mutButtonArray;

@property  (nonatomic, strong) NSArray *mutVCArray;

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation HFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    [self pri_installButtonArray];
    [self pri_installMainTableView];

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
    if (selectRow == 0) {
       [self addAlterVC];
    }else{
        UIViewController *pushVC = [[NSClassFromString(self.mutVCArray[selectRow]) alloc]init];
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }


}

#pragma mark - Private methdods
- (void)pri_installMainTableView
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
- (void)pri_installButtonArray
{
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"blockButton",@"多线程",@"const,Static,Extern",@"runtimeAndProperty",@"interfaceAndAPI",@"Protocol",@"内存管理",nil];

    self.mutVCArray = @[@"alterVC",@"HFMutThreadHomeViewController",@"HFConstStaticExternViewController",@"HFRuntimeAndMethodsViewController",@"HFInterfaceAndAPIViewController",@"HFProtocolAndCategoryViewController",@"HFMemoryViewController"];

}


//这个是目前系统alterview的实现方式
- (void)addAlterVC
{
    
    //    [blockButton handleBlock:^(UIButton *button) {
    //        NSLog(@" =----!!");
    //        [self addAlterVC];
    //    }];
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"AlterView" message:@"UIAlertControllerMessage" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"One" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"button one");
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Two" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"button two");
        
    }];
    
    [alterVC addAction:action1];
    [alterVC addAction:action2];
    
    [self presentViewController:alterVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
