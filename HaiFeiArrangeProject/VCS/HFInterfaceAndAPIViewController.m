//
//  HFInterfaceAndAPIViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/14.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFInterfaceAndAPIViewController.h"
#import "HFSonModel.h"


@interface HFInterfaceAndAPIViewController ()

@end

@implementation HFInterfaceAndAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"InterfaceAndAPI";
    HFFatherModel *fatherModelOne = [[HFFatherModel alloc]init];
    HFFatherModel *fatherModelTwo = [[HFFatherModel alloc]initWithFirstParms:@"twoFirst" secondParms:@"twoSecond"];
    NSLog(@"fatherModelOne = %@,fatherModelTwo = %@",fatherModelOne,fatherModelTwo);
    
    HFSonModel *oneSon = [[HFSonModel alloc]init];
    HFSonModel *twoSon = [[HFSonModel alloc]initWithFirstParms:@"twoSonFirst" secondParms:@"twoSonSecond"];
    
    
   
    
    NSLog(@"oneSon = %@,twoSon = %@",oneSon,twoSon);
    
    
    /*
     HFFatherModel 如果不实现NSCoping协议 下面的执行就会崩溃 因为找不到- (id)copyWithZone:(NSZone *)这个方法的实现
     这样子copyFatherM 和 fatherModelTwo 是两个地址不同的对象
     fatherModelTwo 发生修改 不会影响copyFatherM
     */
    
    HFFatherModel *copyFatherM = [fatherModelTwo copy];
    NSLog(@"copyFatherM =%@",copyFatherM);
    
    fatherModelTwo.firstParms = @"555";
    NSLog(@"-change - copyFatherM = %@,fatherModelTwo = %@",copyFatherM,fatherModelTwo);

    
    HFSonModel *copySon = oneSon;
    //这样子copySon和oneSon 地址信息等完全一致的对象,oneSon修改，copySon也会被修改
    NSLog(@"copySon = %@",copySon);
    
    oneSon.secondParms = @"123";
    NSLog(@"-change - copySon = %@,oneSon = %@",copySon,oneSon);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
