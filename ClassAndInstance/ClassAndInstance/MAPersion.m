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

@interface MethodHelper : NSObject

- (void)method2;

@end


@implementation MethodHelper

- (void)method2
{
    NSLog(@"methodHelper instance:%@,method2SEL:%p",self,_cmd);
}

@end

@interface MAPersion()
{
    MethodHelper *_helper;
}

@end

@implementation MAPersion

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _helper = [[MethodHelper alloc] init];
    }
    return self;
}

- (void)test
{
    [self performSelector:@selector(method2)];
}


/**
 设置备用接受对象

 @param aSelector 不能被识别的 sel
 @return 用来接受不能设备的 sel 对象
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//
//    NSString *selString = NSStringFromSelector(aSelector);
//    if ([selString isEqualToString:@"method2"])
//    {
//        return _helper;
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"%s---%d---",__func__,__LINE__);
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([MethodHelper instancesRespondToSelector:aSelector])
        {
            signature = [MethodHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"%s---%d---",__func__,__LINE__);
    if ([MethodHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}

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

/**
 解决不能接受的 sel,处理的 method1:方法

 @param sel 不能相应的 sel
 @return  是否能够相应
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1:"])
    {
        class_addMethod([self class], @selector(method1:), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}
@end












