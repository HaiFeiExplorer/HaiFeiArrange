//
//  HFSonModel.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFSonModel.h"



@implementation HFSonModel
//@synthesize secondParms = _secondParms;


//如果子类的全能初始化方法与超类的全能初始化方法名称不同，那么总应覆写超类的全能初始化方法
//如果超类的初始化方法不适用字类，那么应该覆写这个超类方法，并在其中抛出异常
//
- (id)initWithSecondpamrs:(NSString *)second
{
    NSLog(@"[self class] = %@ [super class] = %@ ",[self class],[super class]);
    return [super initWithFirstParms:@"Son" secondParms:second];
}
- (id)initWithFirstParms:(NSString *)firstStr secondParms:(NSString *)secondStr
{
    return [self initWithSecondpamrs:secondStr];
}

/*
 每个字类的全能初始化方法都应该调用其超类的对应方法，并逐层向上，实现initWithCoder:也是如此，先调用超类的相关方法，然后再执行与本类有关的任务
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        
    }
    return self;
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"son son %@",[super description]];
}

//- (void)setSecondParms:(NSString *)secondParms
//{
//    if (secondParms) {
//        _secondParms = [NSString stringWithFormat:@"sonAnd%@",secondParms];
//    }else{
//        [NSException raise:NSInvalidArgumentException format:@"不可为空"];
//    }
////    self.secondParms = secondParms;
//}

@end
