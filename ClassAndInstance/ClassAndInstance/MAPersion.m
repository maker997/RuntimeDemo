//
//  MAPersion.m
//  ClassAndInstance
//
//  Created by maker  on 2018/4/26.
//  Copyright © 2018年 maker . All rights reserved.
//

#import "MAPersion.h"
#import <objc/runtime.h>

void functionForMethod1(id self,SEL _cmd)
{
    NSLog(@"%@,%p",self,_cmd);
}

@implementation MAPersion

////- (void)doWork
//{
//    
//}

+ (void)doWork
{
    
}
#pragma mark- NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    MAPersion *p = [MAPersion allocWithZone:zone];
    return p;
}


+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"])
    {
        class_addMethod([self class], @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}
@end
