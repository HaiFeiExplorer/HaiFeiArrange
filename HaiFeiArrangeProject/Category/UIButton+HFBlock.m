//
//  UIButton+HFBlock.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/30.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "UIButton+HFBlock.h"
#import <objc/runtime.h>



static const char buttonActionKeyname;

static void *HFAlterViewKey;



@implementation UIButton (HFBlock)


/*
 使用关联，我们可以不用修改类的定义而为其对象增加存储空间，这主要是在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候非常有用
 涉及到的使用场景：
 1、category的使用，objc_setAssociatedObject/pbjc_getAssociatedObiect实现添加属性
 2、objc_setAssociatedObject与Block的简单使用
 注意：
 1、使用“关联对象”机制把两个对象连起来
 2、模仿添加属性
 3、只有在其他做法不可执行时才会使用关联对象，因为这种做法通常会引入难于查找的bug
 ——————————  ——————  ———————— —————————— ———————— —————————— ———————— —————————— ———————— ———————— ——————
 
 1、void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
 《此方法以给定的键和策略为对象设置关联对象值》
 id object       :表示关联者，是一个对象，变量名理所当然也是object
 const void *key :获取被关联者的索引key
 id value        :被关联的对象
 objc_AssociationPolicy policy : 关联时采用的协议，亦称为关联策略，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
 OBJC_ASSOCIATION_ASSIGN 等价于 @property(assign)。
 OBJC_ASSOCIATION_RETAIN_NONATOMIC等价于 @property(strong, nonatomic)。
 OBJC_ASSOCIATION_COPY_NONATOMIC等价于@property(copy, nonatomic)。
 OBJC_ASSOCIATION_RETAIN等价于@property(strong,atomic)。
 OBJC_ASSOCIATION_COPY等价于@property(copy, atomic)。
 
2、id objc_getAssociatedObject(id object, const void *key);
 《此方法是根据给定的键从某对象中获取相应的关联对象值》
3、void objc_removeAssociatedObjects(id object);
 《此方法移除指定对象的全部关联对象》
 使用函数objc_removeAssociatedObjects可以断开所有关联。通常情况下不建议使用这个函数，因为他会断开所有关联。只有在需要把对象恢复到“原始状态”的时候才会使用这个函数。
 断开关联是使用objc_setAssociatedObject函数，传入nil值即可。
 objc_setAssociatedObject(self, &associatedButtonkey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
 
 */


/*
 这个是为button 添加一个block 事件，和系统的addTarget 相比是代码更简洁，其他的 暂时还没有发现
 
 */
- (void)handleBlock:(hfButtonAction)hfBlock
{
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, &buttonActionKeyname, hfBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)buttonAction:(UIButton *)button
{
    hfButtonAction hfBlcok = (hfButtonAction)objc_getAssociatedObject(self, &buttonActionKeyname);
    if (hfBlcok) {
        hfBlcok(button);
        NSLog(@"block 回调 斯密达");
    }
}

#pragma mark - AlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^blcok)(NSInteger) = objc_getAssociatedObject(alertView, &HFAlterViewKey);
    blcok(buttonIndex);
}

- (void)addAlterView
{
    //UIAlertView 从iOS9开始被废弃了，这个是用这个做了例子，说明objc_setAssociatedObject的作用
    //这样做 可以将alterView 与处理操作之间的代码放在一起，看起来更易理解，实际上目前使用弹框的UIAlertController 实现就类似如此实现
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"title" message:@"Message" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"OK", nil];
    
    void (^block)(NSInteger) = ^(NSInteger buttonIndex){
        
        if (buttonIndex == 0) {
            [self buttonZeroAction];
        }else if (buttonIndex == 1)
            [self buttonOneAction];
    };
    
    objc_setAssociatedObject(alterView, &HFAlterViewKey, block, OBJC_ASSOCIATION_COPY);
    [alterView show];
    
    
    //或者是 在tableView中 如果每个cell上都有一个点击事件 弹出一个view，可以用
    /*
     然后这里设定关联，此处把indexPath关联到alert上
    objc_setAssociatedObject(alert, &kUITableViewIndexKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    然后在需要使用地方取出，而不需要频繁设置全局变量或属性实现indexpath的传递
     */
  
}

- (void)buttonZeroAction
{
    NSLog(@"button index = 0");
}

- (void)buttonOneAction
{
    NSLog(@"button Index = 1");
}

@end
