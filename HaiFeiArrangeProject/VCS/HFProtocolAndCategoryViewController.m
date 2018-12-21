//
//  HFProtocolAndCategoryViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/16.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFProtocolAndCategoryViewController.h"
#import "HFFatherModel.h"


@interface HFProtocolAndCategoryViewController ()<HFTestProtocol>

@end

@implementation HFProtocolAndCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Protocol";
    HFFatherModel *fatherMdodel = [[HFFatherModel alloc]init];
    fatherMdodel.delegate = self;
    
    [fatherMdodel  protocol_fatherModelProtocolForRequireSth:@"require"];
    [fatherMdodel  protocol_fatherModelProtocolForOptionalSth:@"require"];

}
#pragma mark -HFTestProtocol
- (void)testProtocolMustDoSomething:(NSString *)string
{
    NSLog(@"string = %@ cmd = %@",string,NSStringFromSelector(_cmd));
}
- (void)testProtocolOptinalDoSomething:(NSString *)string
{
    NSLog(@"string = %@ cmd = %@",string,NSStringFromSelector(_cmd));

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
