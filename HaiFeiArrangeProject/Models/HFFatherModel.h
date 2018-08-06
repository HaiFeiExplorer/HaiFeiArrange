//
//  HFFatherModel.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFFatherModel : NSObject

@property (nonatomic, copy) NSString *firstParms;
@property (nonatomic, copy) NSString *secondParms;

+ (void)testObjc_msgSend;

- (id)initWithFirstParms:(NSString *)firstStr secondParms:(NSString *)secondStr;

- (void)runtimeTest;

-(void)classMethodName;

- (void)exchangeMethodA;
- (void)exchangeMethodB;
- (void)replaceMethodsAction;


@end
