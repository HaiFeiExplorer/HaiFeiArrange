//
//  HFInterfaceAndAPIViewController.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/14.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFBaseViewController.h"

//《Effective Objective-C》第三章之接口和API的设计


/*
 关于命名规则：
 1、用前缀避免命名空间冲突
 2、使用清晰而协调的命名方式
    起名时应遵从标准的OC的命名规范，这样创建出来的接口更容易为开发者所理解
    方法名要言简意赅，从左到右读起来像一个日常的句子才好
    方法名不要使用缩略后的类型名称
    给方法起名的时的第一要务就是确保其风格和自己的代码或所要集成的框架相符
 3、为私有方法名加前缀
    给私有方法的名称加上前缀，这样容易和公共方法区分开
    不要单用一个下划线做私有方法的前缀，因为这种方法是预留给苹果公司的
 
 理解Objective-C的错误类型
 如果抛出异常，那么本应该在作用域末尾释放的对象就不会自动释放了！
 OC所采用的方法是：只有在极其罕见的情况下抛出异常，异常抛出之后，无须考虑恢复问题，而且应用程序此时也应该退出，也就是说不用再编写复杂的“异常安全”代码
  一般是把错误信息放在NSError对象中，经由“输出参数”返回给调用者
 
 关于NScopying协议：
 若想令自己所写的对象具有拷贝功能，需要实现NScopying协议
 如果自定义的对象分可变和不可变版本，那么需要同时实现NScopying与NSMutableCopying协议
 复制对象时需决定采用深拷贝还是浅拷贝，一般情况下应该尽量使用浅拷贝
 如果所写的对象需要深拷贝，那么可考虑新增一个专门执行深拷贝的方法
 
 */

@interface HFInterfaceAndAPIViewController : HFBaseViewController

@end
