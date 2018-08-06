//
//  UIButton+HFBlock.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/30.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hfButtonAction)(UIButton *button);


//为了验证objc_setAssociatedObject 相关的关联对象的部分东西
@interface UIButton (HFBlock)<UIAlertViewDelegate>

- (void)handleBlock:(hfButtonAction)hfBlock;

- (void)addAlterView;
@end
