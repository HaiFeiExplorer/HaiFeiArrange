//
//  HFConstStaticExternViewController.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFConstStaticExternViewController.h"
#import "HFGlobleHandleObject.h"


static NSString *const kConstatCellID = @"constCellID";


//#define kConstatCellID @"kConstatCellID"



@interface HFConstStaticExternViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *mutButtonArray;

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation HFConstStaticExternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kConstatCellID];
    cell.textLabel.text = self.mutButtonArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self staticForParmsAction];
            break;
        case 1:
            [self staticForWholection];
            break;
        case 2:
            [self constDetailActin];
            break;
        case 3:
            [self externDetailAction];
            break;
        case 4:
            [self constWithExternAction];
            break;
        case 5:
            [self constWithStaticAction];
            break;
        default:
            break;
    }
}
#pragma mark - Event response
#warning message -- 涉及到的作用域的问题需要验证之后再议

- (void)staticForParmsAction
{
    /*
     static:修饰局部变量和全局变量
     修饰局部变量：
     1、让局部变量只初始化一次
     2、局部变量在程序中只有一份内存
     3、不会改变局部变量的作用域（需要验证，验证之后再议），只是改变了局部变量的声明周期（只有程序结束，这个局部变量才销毁，这样下次使用的时候还会保持上次的值）
     */
    [self staticForPartParmsStatic:NO];
    [self staticForPartParmsStatic:NO];
    [self staticForPartParmsStatic:NO];
    [self staticForPartParmsStatic:YES];
    [self staticForPartParmsStatic:YES];
    [self staticForPartParmsStatic:YES];
    /*
      tempNum地址 = 0x7fff573fc198,tempNum = 21
      tempNum地址 = 0x7fff573fc198,tempNum = 21
      tempNum地址 = 0x7fff573fc198,tempNum = 21
      static 修饰的 tempNum地址 = 0x10880d250,tempNum = 21
      static 修饰的 tempNum地址 = 0x10880d250,tempNum = 22
      static 修饰的 tempNum地址 = 0x10880d250,tempNum = 23
     结果可以看出 有static关键字修饰的变量，地址始终不变！
     */
    
}
int tempWholeNUm = 0;
//static int tempStaticWholeNum;
- (void)staticForWholection
{
    /*
     static:修饰局部变量和全局变量
     修饰全局变量：
     1、作用域仅限于当前文件
     2、项目的其他文件不能使用extern引用变量
     具体可搜索打开 “tempStaticWholeNum”部分代码，并尝试在其他文件使用！
     */
    NSLog(@"具体可搜索打开 “tempStaticWholeNum”部分代码，并尝试在其他文件使用！");
    
}
- (void)constDetailActin
{
    //const的作用：
    /*
     1、修饰右边的基本变量和指针变量
     2、被const修饰的变量是只读的，不可修改
     使用场景：
     修饰全局变量-->次变量为只读变量-->可代替宏
     修饰方法中的参数
     */
    //没有const修饰的指针以及改指针指向的值都可以被多次修改
    //被const修饰的*p只能被赋值一次，之后不能赋值，否则编译器会报错；被const修饰的p只能存一次地址，否编译器报错
   //注释掉的三行可以分别打开验证！
//    const  int *tempP = NULL; --- 会导致*tempP = 99;这样的操作报错 不能修改*p的值
//    int const *tempP = NULL; --- 会导致*tempP = 99;这样的操作报错 不能修改*p的值
//    int *const tempP = NULL; --会导致 tempP = &tempNumA; 这样的操作报错 ，不能修改p的值
   //示例：
/*
 
    //定义一个指针变量
    int *tempP = NULL;
    //定义两个int 类型的变量
    int tempNumA = 10;
    
    NSLog(@"tempNumA = %d ,地址&tempNumA = %p",tempNumA,&tempNumA);
    int tempNumB = 20;
    
    NSLog(@"tempNumB = %d ,地址&tempNumB = %p",tempNumB,&tempNumB);


    //指针p指向A,然后设置指针p的内容---结果就是A的指针的内容（也就是变量）发生了修改
    tempP = &tempNumA;
    *tempP = 99;
    NSLog(@"--指向A后--地址tempP = %p ,*tempP = %d",tempP,*tempP);

    
    //指针p指向B
    tempP = &tempNumB;
    *tempP = 55;
    NSLog(@"--指向B后--地址tempP = %p ,*tempP = %d",tempP,*tempP);
    NSLog(@" - 2- tempNumA = %d ,地址&tempNumA = %p",tempNumA,&tempNumA);
    NSLog(@"- 2- tempNumB = %d ,地址&tempNumB = %p",tempNumB,&tempNumB);
*/
   //关于const的修饰的位置（就近修饰原则）
    /*
     int const *p1,表示*p1不能修改
     int *const p2,表示p2不能修改
     Eg：
     NSString *tempStr = @"temp";
     如果不想其他人修改tempStr的值的话：
     NSString *const tempStr = @"temp";
     tempStr = @"123";
     强制就修改“Cannot assign to variable 'tempStr' with const-qualified type 'NSString *const __strong'”
     */

//const 和 宏的区别：
    /*
     1、编译时刻：宏是预编译；const是编译
     2、编译检查：宏没有编译检查，不会报编译错误，只是替换；const有编译检查，会报编译错误
     3、宏的好处：宏可以定义一些函数、方法，const不能
     4、宏的坏处：大量的使用宏，会导致预编译时间过长，每次都需要重新替换！
     注意:很多Blog都说使用宏，会消耗很多内存，我这验证并不会生成很多内存，宏定义的是常量，常量都放在常量区，只会生成一份内存。 《参考链接：https://blog.csdn.net/chen_gp_x/article/details/53149524》
     关于涉及到的地址这个方面在之后地址的整理中会详细说明
     
     */

}
- (void)externDetailAction
{
    //extern
    /*
     作用:声明外部全局变量,或者说只是用来获取全局变量（包括全局静态变量）的值，不能用于定义变量
     工作原理：现在当前文件查找有没有全局变量，没有找到才会在其他文件查找
     
     */
    NSLog(@"extern 一般是和 const 一起使用");
}
- (void)constWithExternAction
{
    //extern和const的结合使用
    /*
     使用场景：在多个文件中经常使用的同一个字符串常量，
     注意：开发使一般规定，为了避免重复报错，全局变量不能定义在自己的类中，我们需要创建一个专门用来管理全局变量的文件，例如一个全局类()
     */
    NSLog(@"hfConstTempName = %@",hfConstTempName);
    
}
- (void)constWithStaticAction
{
    //static和const的结合使用
    /*
     作用：声明一个只读的全局静态变量
     场景：在一个文件中经常使用的字符串常量，可以使用static与const组合
     
     */
}
#pragma mark - Private methdos

- (void)installMainTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kConstatCellID];
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.rowHeight = 50;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}
- (void)installButtonArray
{
    self.mutButtonArray = [NSMutableArray arrayWithObjects:@"Static 局部变量",@"Static 全局变量",@"Const",@"Extern",@"Const and Extern",@"Const and Static",nil];
}
/**
 局部变量
 isStatic YES 是static 修饰 NO无static修饰
 @return
 */

- (void)staticForPartParmsStatic:(BOOL)isStatic
{
    if (isStatic) {
        static int tempNum = 20;
        tempNum ++;
        NSLog(@"static 修饰的 tempNum地址 = %p,tempNum = %d",&tempNum,tempNum);
       
    }else{
        int tempNum = 20;
        tempNum ++;
        NSLog(@"tempNum地址 = %p,tempNum = %d",&tempNum,tempNum);
    }
 
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
