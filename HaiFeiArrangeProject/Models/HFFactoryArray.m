//
//  HFFactoryArray.m
//  HaiFeiArrangeProject
//
//  Created by unionx on 2018/7/27.
//  Copyright © 2018年 HaiFeiExplorer. All rights reserved.
//

#import "HFFactoryArray.h"

@implementation HFFactoryArray
- (NSUInteger)count
{
    return [super count];
}
- (id)objectAtIndex:(NSUInteger)index
{
    return [super objectAtIndex:index];
}
- (instancetype)init
{
    return [super init];
    __unsafe_unretained NSArray * _Nonnull arryObjects = @[@"one",@"two",@"三"];
//    NSArray *tempArray = [[NSArray alloc]initWithObjects:arryObjects count:2];
}
//- (instancetype)initWithObjects:(NSArray*)objects count:(NSUInteger)cnt
//{
//    return [super initWithObjects:objects count:cnt];
//    
//}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
    
}
@end
