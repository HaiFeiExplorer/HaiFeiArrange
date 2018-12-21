//
//  NSString+HFMethodExChange.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/1.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 运行时 之 方法调配技术：包括新增方法 或替换（交换方法）
 1、在不知道某些具体实现的的类中（也就是黑盒子的情况下），可以添加日志记录功能
 2、只有在调式程序的时候才需要在运行期间修改方法实现
 3、不要滥用，否则会使代码不易读懂且难以维护！
 */

@interface NSString (HFMethodExChange)

@end
