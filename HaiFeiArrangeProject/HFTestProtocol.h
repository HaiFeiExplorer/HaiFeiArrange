//
//  HFTestProtocol.h
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/8/16.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@protocol HFTestProtocol <NSObject>


- (void)testProtocolMustDoSomething:(NSString *)string;

@optional
- (void)testProtocolOptinalDoSomething:(NSString *)string;

@end
