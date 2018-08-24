//
//  HFFatherModel.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFTestProtocol.h"



@interface HFFatherModel : NSObject<NSCoding,NSCopying>

/*
 尽量使用不可变对象
 一般而言可以声明为read-only，默认情况下是read-write，这样子的是可变的
 一般尽量把公布到外部的属性设置为只读，且只在确定有必要时才将属性对外公布

 一般如果对象有collection的属性，一般是设置为不可读，然后在添加其增加和删除等修改collection的方法
 
 */

@property (nonatomic, copy) NSString *firstParms;
@property (nonatomic, copy) NSString *secondParms;


@property (nonatomic, weak) id<HFTestProtocol>delegate;


+ (void)testObjc_msgSend;

- (id)initWithFirstParms:(NSString *)firstStr secondParms:(NSString *)secondStr;

- (void)runtimeTest;

-(void)classMethodName;

- (void)exchangeMethodA;
- (void)exchangeMethodB;
- (void)replaceMethodsAction;

//协议相关的方法
- (void)protocol_fatherModelProtocolForRequireSth:(NSString *)something;
- (void)protocol_fatherModelProtocolForOptionalSth:(NSString *)something;

@end
