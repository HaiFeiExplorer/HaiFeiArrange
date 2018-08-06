//
//  HFSonModel.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/26.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFSonModel.h"



@implementation HFSonModel
@synthesize secondParms = _secondParms;

- (void)setSecondParms:(NSString *)secondParms
{
    if (secondParms) {
        _secondParms = [NSString stringWithFormat:@"sonAnd%@",secondParms];
    }else{
        [NSException raise:NSInvalidArgumentException format:@"不可为空"];
    }
//    self.secondParms = secondParms;
}

@end
